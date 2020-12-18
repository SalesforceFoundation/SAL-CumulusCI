import base64
import io
import json
import time
import zipfile
from datetime import datetime
from pathlib import Path

from cumulusci.salesforce_api.exceptions import MetadataApiError
from cumulusci.tasks.salesforce import Deploy


class CheckDeploy(Deploy):
    command = "force:mdapi:deploy --json"

    task_options = {
        "path": {
            "description": "The path to the metadata source to be checked",
            "required": True,
        },
        "timeout": {
            "description": "The max amount of time to wait in seconds",
            "required": True,
        },
        "unmanaged": {
            "description": "If True, changes namespace_inject to replace tokens with a blank string"
        },
        "namespace_inject": {
            "description": "If set, the namespace tokens in files and filenames are replaced with the namespace's prefix"
        },
        "namespace_strip": {
            "description": "If set, all namespace prefixes for the namespace specified are stripped from files and filenames"
        },
        "namespace_tokenize": {
            "description": "If set, all namespace prefixes for the namespace specified are replaced with tokens for use with namespace_inject"
        },
        "static_resource_path": {
            "description": "The path where decompressed static resources are stored.  Any subdirectories found will be zipped and added to the staticresources directory of the build."
        },
        "namespaced_org": {
            "description": "If True, the tokens %%%NAMESPACED_ORG%%% and ___NAMESPACED_ORG___ will get replaced with the namespace.  The default is false causing those tokens to get stripped and replaced with an empty string.  Set this if deploying to a namespaced scratch org or packaging org."
        },
    }

    def _init_options(self, kwargs):
        super()._init_options(kwargs)
        self.options["timeout"] = int(self.options["timeout"])
        self.api_class.soap_envelope_start = self.api_class.soap_envelope_start.replace(
            "<checkOnly>false", "<checkOnly>true"
        )

    def _run_task(self):
        self.counter = 0
        self.time_start = datetime.now()
        while self._should_continue():
            try:
                super()._run_task()
                break
            except MetadataApiError as e:
                self.counter += 1
                if not self._check_count():
                    raise e
                else:
                    time.sleep(30)

    def _should_continue(self):
        return self._check_count and self._check_timeout

    def _check_timeout(self):
        elapsed = datetime.now() - self.time_start
        return elapsed.total_seconds() < self.options["timeout"]

    def _check_count(self):
        return self.counter <= 5
