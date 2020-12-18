from datetime import datetime
from cumulusci.core.exceptions import CumulusCIException
from cumulusci.tasks.salesforce import BaseSalesforceApiTask


class FieldNotWritable(CumulusCIException):
    pass


class WaitForSharing(BaseSalesforceApiTask):
    task_options = {
        "object": {
            "description": "The name of the object to check for, (ex: OpportunityShare)",
            "required": True,
        },
        "field": {
            "description": "The name of the field to check, (ex: OpportunityId)",
            "required": True,
        },
        "timeout": {
            "description": "The max amount of time to wait in seconds",
            "required": True,
        },
    }

    def _init_options(self, kwargs):
        super(WaitForSharing, self)._init_options(kwargs)
        self.options["timeout"] = int(self.options["timeout"])

    def _run_task(self):
        self.time_start = datetime.now()
        self._poll()
        self.logger.info("Object {object} is available!".format(**self.options))

    def _poll_action(self):
        elapsed = datetime.now() - self.time_start
        if elapsed.total_seconds() > self.options["timeout"]:
            raise FieldNotWritable(
                "{object} not available after {timeout} seconds".format(**self.options)
            )
        obj = getattr(self.sf, self.options["object"]).describe()
        for field in obj["fields"]:
            if field["name"] != self.options["field"]:
                continue
            if field["createable"]:
                self.poll_complete = True
