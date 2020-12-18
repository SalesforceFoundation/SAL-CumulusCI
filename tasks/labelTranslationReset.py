from cumulusci.core.tasks import BaseTask
from lxml import etree as ET


class LabelTranslationDestructor(BaseTask):
    task_options = {
        "path": {"description": "Path to the translation file", "required": True}
    }

    def _run_task(self):
        translationPath = self.options["path"]
        with open(translationPath) as translationFile:
            translationTree = ET.parse(translationFile)

        translationRoot = translationTree.getroot()
        ET.strip_elements(translationRoot, "*")

        translationTree.write(
            translationPath, encoding="utf-8", xml_declaration=True, pretty_print=True
        )
