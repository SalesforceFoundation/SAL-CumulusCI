# Salesforce Advisor Link Express Setup

This read-only repository contains CumulusCI automation and unmanaged metadata components used in the Advisor Link MetaDeploy installer.

Visit the [Advisor Link topic](https://trailhead.salesforce.com/trailblazer-community/groups/0F94S000000kHhtSAE?tab=discussion&sort=LAST_MODIFIED_DATE_DESC) on the Power of Us Hub for any questions about this repository.

## Base Plan

The base plan installs the minimal, core packages required to run Advisor Link: Education Data Architecture, Advisor Link, and Pathways. It is required for all orgs.

| Task                          | MetaDeploy Step                           | Description                                                                                                     |
| ----------------------------- | ----------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| `update_dependencies.1`       | EDA - Account Record Types                | Deploys Account record types for EDA.                                                                           |
| `update_dependencies.2`       | EDA - Contact Key Affiliation Fields      | Deploys Contact Key Affiliation fields for EDA.                                                                 |
| `update_dependencies.3`       | Install EDA                               | Updates or installs the Education Data Architecture managed package.                                            |
| `update_dependencies.4`       | EDA - Case Behavior Record Types          | Deploys Case Behavior record types for EDA.                                                                     |
| `update_dependencies.5`       | EDA - Course Connection Record Types      | Deploys Course Connection record types for EDA.                                                                 |
| `update_dependencies.6`       | EDA - Facility Display Name Formula Field | Deploys the Facility Display Name formula field for EDA.                                                        |
| `update_dependencies.7`       | Install Pathways                          | Updates or installs the Pathways managed package.                                                               |
| `deploy_pre`                  | Advisor Link - Prerequisite Record Types  | Deploys required record types for the Event and Case objects.                                                   |
| `install_managed`             | Install SAL                               | Installs the current version of the Advisor Link managed package.                                               |
| `deploy_post`                 | Advisor Link - Unpackaged Metadata        | Deploys unpackaged metadata, including record types, custom tabs, and metadata associated with Lightning pages. |
| `custom_settings_insert_base` | Advisor Link - Custom Settings            | Inserts Advisor Link custom settings.                                                                           |

(Note: While `update_dependencies` is a single task, it maps to multiple MetaDeploy Steps)

## Express Setup Configuration Plan

The Express Setup configuration provides optional unmanaged metadata such as
record types, page layouts, and profiles and permission sets. The Express Setup
configuration plan requires that you first successfully install the base plan.
When you install the Express Setup configuration plan, you still need to
customize the metadata for your org, but it gives you a good start on getting
Advisor Link up and running. As a result, it's recommended for all
customers.

| Task                               | MetaDeploy Step                                   | Description                                                                                                                                                                                   |
| ---------------------------------- | ------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `deploy_hed_config`                | Express Setup - Additional Unpackaged Metadata    | Deploys additional unpackaged metadata including Reports and Dashboards, Flows, page layouts, object customizations, quick actions, user roles, and metadata associated with Lightning pages. |
| `deploy_hed_reports_dashboards`    | Express Setup - Sample Reports and Dashboards     | Inserts a sample dashboard and sample reports                                                                                                                                                 |
| `deploy_hed_app_profile`           | Express Setup - Lightning App and Advisor Profile | Deploys the Advisor Link Lightning app and the Advisor Link Advisor profile.                                                                                                                  |
| `deploy_hed_plus_advisee_profile`  | Express Setup - Advisee Profile                   | Deploys the Advisor Link Advisee profile.                                                                                                                                                     |
| `deploy_hed_login_advisee_profile` | Express Setup - Advisee Portal Profile            | Deploys the Advisor Link Advisee Login profile for the sample advisee portal.                                                                                                                 |
| `deploy_hed_permission_sets`       | Express Setup - Permission Sets                   | Deploys permission sets for the advisor and advisee profiles.                                                                                                                                 |
| `deploy_advisor_sharing_rules`     | Express Setup - Advisor Sharing Metadata          | Deploys sharing rules for the Alert, Success Plan, and Success Plan Template objects.                                                                                                         |

## Express Setup Sample Portal Plan

The Express Setup sample portal plan provides a sample advisee portal
(community). The Express Setup sample portal plan requires that you first
successfully install the base and configuration plans. The Express Setup sample
portal plan is recommended for partners.

| Task                             | MetaDeploy Step                                      | Description                                                                                                                                                                                                          |
| -------------------------------- | ---------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `deploy_hed_portal_org_settings` | Express Setup - Advisee Portal Organization Settings | Deploys organization settings that enable the ExperienceBundle Metadata API.                                                                                                                                         |
| `create_community`               | Express Setup - Sample Advisee Portal                | Inserts a sample, unpublished advisee portal.                                                                                                                                                                        |
| `deploy_hed_portal`              | Express Setup - Advisee Portal Unpackaged Metadata   | Deploys ExperienceBundle, navigation menu, Network, Site, and other metadata for the sample advisee portal. This step requires that you've run the Express Setup - Sample Advisee Portal Organization Settings step. |
| `deploy_advisee_sharing_rules`   | Express Setup - Advisee Portal Sharing Metadata      | Deploys sharing rules for the Account and User objects, and a sharing set for Cases and Course Connections.                                                                                                          |

## Express Setup Sample Data Plan

The Express Setup sample data plan provides optional sample data
that you can use to test or demo features. Sample data includes
advisor and advisee personas, terms and courses, and advisor
availability. The Express Setup sample data plan requires that you
first successfully install the base, configuration, and sample
portal plans. The Express Setup sample data plan is recommended for
partners.

| Task                          | MetaDeploy Step                                                                  | Description                                                                                                                                                                                                                                                                                                    |
| ----------------------------- | -------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `deploy_hed_data_1`           | Express Setup - Basic Sample Data                                                | Inserts sample demo data in the org, including Accounts, Affiliations, Cases, Contacts, Courses, Facilities, Program Enrollments, Success Plan Templates, and Topics. For compatibility with community metadata, this step also applies the IT role to the running User. You can reset the role after install. |
| `insert_hed_terms`            | Express Setup - Sample Data for Terms                                            | Inserts sample demo data for Terms.                                                                                                                                                                                                                                                                            |
| `insert_hed_course_offerings` | Express Setup - Sample Data for Course Offerings                                 | Inserts sample demo data for Course Offerings.                                                                                                                                                                                                                                                                 |
| `deploy_hed_data_2`           | Express Setup - Sample Data for Course Connections and Course Offering Schedules | Inserts sample demo data for Course Connections and Course Offering Schedules.                                                                                                                                                                                                                                 |
| `upload_photo_adam`           | Express Setup - Sample Advisor Photo                                             | Uploads a photo for the Advisor Link advisor persona.                                                                                                                                                                                                                                                          |
| `upload_photo_sophia`         | Express Setup - Sample Advisee Photo                                             | Uploads a photo for the Advisor Link advisee persona.                                                                                                                                                                                                                                                          |
| `insert_hed_availability`     | Express Setup - Sample Data for Advising Availability                            | Inserts sample Event and other data for advising availability.                                                                                                                                                                                                                                                 |
| `schedule_hed_apex_last_appt`     | Express Setup - Scheduled Apex Job That Collects Last Appointment Data       | Scheduled Apex job that collects last appointment data.                                                                                                                                                                                                                                                 |
| `schedule_hed_apex_task_summary_count`     | Express Setup - Scheduled Apex Job That Recalculates Success Plan Task Summary Counts       | Scheduled Apex job that recalculates Success Plan Task summary counts.                                                                                                                                                                                                                                                 |
