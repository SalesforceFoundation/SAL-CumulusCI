import base64
import copy
import csv
import json
import random
import string
from pathlib import Path

from cumulusci.cli.ui import CliTable
from cumulusci.core.config import ScratchOrgConfig
from cumulusci.core.exceptions import TaskOptionsError
from cumulusci.core.exceptions import CumulusCIFailure
from cumulusci.core.utils import process_bool_arg
from cumulusci.tasks.salesforce import BaseSalesforceApiTask
from cumulusci.tasks.sfdx import SFDXOrgTask
from cumulusci.utils import temporary_dir

DEFAULT_ADVISEE_RECORD_TYPE = "AdviseeRecord"
DEFAULT_COMMUNITY_NAME = "AdviseeCommunity"


class SalUserGenerator(BaseSalesforceApiTask):
    """Parse a CSV file and create users."""

    task_options = {
        "path": {"description": "The path to the user CSV file.", "required": True},
        "email": {
            "description": "The base email address to use for the created usernames. Defaults to the scratch org user's address."
        },
        "create_advisee_records": {
            "description": "Boolean controlling whether advisee records should be created. Defaults to True."
        },
        "should_upload_photos": {
            "description": "Boolean controlling whether user photos. Defaults to True."
        },
        "user_photo_dir": {
            "description": "The path to a directory containing user photos in JPEG format. "
            "Each photo to be uploaded should be named with the corresponding user alias ('alias0' -> 'alias0.jpg'). "
            "Limited to 25 photos, with a total size <25MB. Required if 'should_upload_photos' is set."
        },
        "community_name": {
            "description": f"The developer name for which advisee user photos should be set. "
            "Defaults to '{DEFAULT_COMMUNITY_NAME }'."
        },
        "advisee_record_type": {
            "description": f"Record Type for Advisee Records. Defaults to {DEFAULT_ADVISEE_RECORD_TYPE}."
        },
    }

    def _init_options(self, kwargs):
        super()._init_options(kwargs)
        self.csv_path = Path(self.options["path"])
        if not self.csv_path.is_file():
            raise TaskOptionsError("User data CSV file not found.")

        self.record_type_name = self.options.get(
            "advisee_record_type", DEFAULT_ADVISEE_RECORD_TYPE
        )
        self.community_name = self.options.get("community_name", DEFAULT_COMMUNITY_NAME)
        self.create_advisee_records = process_bool_arg(
            self.options.get("create_advisee_records", True)
        )
        self.should_upload_photos = process_bool_arg(
            self.options.get("should_upload_photos", True)
        )

        if self.should_upload_photos and "user_photo_dir" in self.options:
            self.user_photo_dir = Path(self.options["user_photo_dir"])
        elif self.should_upload_photos and "user_photo_dir" not in self.options:
            raise TaskOptionsError(
                '"user_photo_dir" required when "should_upload_photos" is set.'
            )

    def _run_task(self):
        self._load_csv()
        if self.create_advisee_records:
            self._upload_contacts()
        self._upload_users()
        self._assign_permsets()
        if self.should_upload_photos:
            self._upload_photos()
        if self.create_advisee_records:
            self._upload_cases()

    def _load_csv(self):
        """
        Read the user CSV, extracting users, permsets, and profiles into class variables.
        """
        self.options["email"] = (
            self.options["email"]
            if "email" in self.options
            else self.org_config.email_address
        )

        with self.csv_path.open() as user_csv:
            user_dicts = [self._replace_email(row) for row in csv.DictReader(user_csv)]
            self.logger.info(f"Found {len(user_dicts)} users in {str(self.csv_path)}")

        self.users = {user["Username"]: user for user in user_dicts}
        self.permsets = {
            user["permsets"]: None for user in user_dicts if "permsets" in user
        }
        self.profiles = {
            user["profileName"]: None for user in user_dicts if "profileName" in user
        }

    def _upload_contacts(self):
        """Iterate over the userlist and create/upload a contact for each user."""
        contacts_to_insert = [
            {
                "attributes": {"type": "Contact"},
                "FirstName": user["FirstName"],
                "LastName": user["LastName"],
                "HomePhone": user["Phone"],
                "MailingState": user["State"],
                "MailingCity": user["City"],
                "MailingPostalCode": user["PostalCode"],
                "MailingStreet": user["Street"],
                "Email": user["Email"],
            }
            for user in self.users.values()
        ]

        self.logger.info(f"Creating {len(contacts_to_insert)} Advisee Contacts")
        contact_result = self._composite_request(contacts_to_insert)

        for i, save_result in enumerate(contact_result):
            contacts_to_insert[i]["Id"] = save_result["id"]

        result_data = [["Email", "Id"]]
        for contact in contacts_to_insert:
            email = contact["Email"]
            contact_id = contact["Id"]
            self.users[email]["ContactId"] = contact_id
            result_data.append([email, contact_id])

        result_table = CliTable(result_data, title="Contacts")
        self.logger.info("\n" + str(result_table))

    def _upload_cases(self):
        """
        Iterate over the userlist and create/upload a case for each user,
        assigning the correct record type.
        """
        record_type = self.sf.query(
            f"SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = '{self.record_type_name}'"
        )
        record_type_id = record_type["records"][0]["Id"]
        self.logger.info(
            f"Found RecordTypeId '{record_type_id}' for Name '{self.record_type_name}'"
        )

        cases_to_insert = [
            {
                "attributes": {"type": "Case"},
                "ContactId": user["ContactId"],
                "Subject": f'{user["FirstName"] + " " + user["LastName"] + " Advisee Record"}',
                "RecordTypeId": record_type_id,
            }
            for user in self.users.values()
        ]
        case_result = self._composite_request(cases_to_insert)

    def _upload_users(self):
        """
        Iterate over the list of users, querying the org for listed permission
        sets and profiles, and assigning those to the appropriate fields before
        uploading via REST.
        """
        profile_names = self._join_query_strings(self.profiles.keys())
        profile_result = self.sf.query(
            f"SELECT Id, Name FROM Profile WHERE Name IN {profile_names}"
        )
        profile_names = list(self.profiles.keys())
        for record in profile_result["records"]:
            self.profiles[record["Name"]] = record["Id"]

        users_to_insert = []
        for user_orig in self.users.values():
            user = copy.deepcopy(user_orig)
            del user["permsets"]
            profile_name = user.pop("profileName")
            user["ProfileId"] = self.profiles[profile_name]
            user["attributes"] = {"type": "User"}
            users_to_insert.append(user)

        self.logger.info(
            f"Creating {len(users_to_insert)} users in {str(self.csv_path)}"
        )
        user_result = self._composite_request(users_to_insert)

        result_data = [["Username", "Id"]]
        for i, result in enumerate(user_result):
            username = users_to_insert[i]["Username"]
            user_id = result["id"]
            self.users[username]["Id"] = user_id
            result_data.append([username, user_id])

        result_table = CliTable(result_data, title="Users")
        self.logger.info("\n" + str(result_table))

    def _assign_permsets(self):
        permset_names = self._join_query_strings(self.permsets.keys())
        permset_result = self.sf.query(
            f"SELECT Id, Name FROM PermissionSet WHERE Name IN {permset_names}"
        )
        for record in permset_result["records"]:
            self.permsets[record["Name"]] = record["Id"]

        permset_assignments = [
            {
                "attributes": {"type": "PermissionSetAssignment"},
                "AssigneeId": user["Id"],
                "PermissionSetId": self.permsets[user["permsets"]],
            }
            for user in self.users.values()
        ]
        self.logger.info("Assigning permission sets")
        psa_result = self._composite_request(permset_assignments)

    def _upload_photos(self):
        content_versions = self._upload_content_versions()
        cv_titles = self._join_query_strings([cv["Title"] for cv in content_versions])
        content_document_result = self.sf.query(
            f"SELECT Id, ContentDocumentId, Title FROM ContentVersion WHERE Title IN {cv_titles}"
        )
        self._attach_photos_to_users(content_document_result["records"])

    def _upload_content_versions(self):
        aliases_dict = {user["Alias"]: user["Id"] for user in self.users.values()}
        content_versions = []
        for alias, user_id in aliases_dict.items():
            photo_path = Path(self.user_photo_dir, alias + ".jpg")

            if not photo_path.is_file():
                self.logger.warning(f'Photo for user alias "{alias}" not found')
                continue

            content_versions.append(
                {
                    "attributes": {"type": "ContentVersion"},
                    "PathOnClient": photo_path.name,
                    "Title": user_id,
                    "VersionData": base64.b64encode(photo_path.read_bytes()).decode(
                        "utf-8"
                    ),
                }
            )

        self.logger.info(f"Uploading {len(content_versions)} user photos")
        content_version_result = self._composite_request(content_versions)
        return content_versions

    def _attach_photos_to_users(self, records):
        url_prefix = "connect"
        if self.create_advisee_records:
            community_id = self._get_community_id()
            url_prefix = f"{url_prefix}/communities/{community_id}"

        for content_version in records:
            self.sf.restful(
                f'{url_prefix}/user-profiles/{content_version["Title"]}/photo',
                data=json.dumps({"fileId": content_version["ContentDocumentId"]}),
                method="POST",
            )

    def _composite_request(self, objects_to_insert):
        request = {"allOrNone": True, "records": objects_to_insert}
        result = self.sf.restful(
            "composite/sobjects", method="POST", data=json.dumps(request)
        )

        request_succeeded = all((record["success"] for record in result))
        if not request_succeeded:
            combined_result = [
                {"request": req, "result": res}
                for req, res in zip(objects_to_insert, result)
            ]
            self.logger.error(json.dumps(combined_result, indent=2))
            raise CumulusCIFailure("REST API Error")

        return result

    def _get_community_id(self):
        """Retrieves the Id for the community_name task option"""
        self.logger.info(f'Looking up ID for community "{self.community_name}"')
        community_list = self.sf.restful("connect/communities")["communities"]
        communities = {c["name"]: c for c in community_list}
        if self.community_name in communities:
            community_id = communities[self.community_name]["id"]
            self.logger.info(
                f'Found ID "{community_id}" for community "{self.community_name}"'
            )
            return community_id

    def _replace_email(self, user_dict):
        """
        Replace the username and email in the datafile with the task option value.
        """
        email = self.options.get("email", "tester@example.com")
        if email and "@" in email:
            local_part, domain_part = email.split("@")
        else:
            raise TaskOptionsError(f"'Email' option ('{email}') is not valid")

        user_name = user_dict["FirstName"] + user_dict["LastName"]
        new_email = f"{local_part}+{user_name}{self._random_str()}@{domain_part}"
        for key in ["Username", "Email"]:
            # lowercase to match API SOQL query result
            user_dict[key] = new_email.lower()
        return user_dict

    def _random_str(self):
        rand_str = "".join(random.choice(string.ascii_lowercase) for _ in range(3))
        return self.org_config.org_id + rand_str

    def _join_query_strings(self, strings):
        """Given a list of strings, return in SOQL WHERE format."""
        formatted_list = ",".join([f"'{element}'" for element in strings])
        formatted_list = f"({formatted_list})"
        return formatted_list
