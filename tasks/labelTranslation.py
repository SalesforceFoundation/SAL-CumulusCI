import sys
import os
import csv
from cumulusci.core.tasks import BaseTask
from pathlib import Path
from lxml import etree as ET
from itertools import chain

MD_NS = {"ns": "http://soap.sforce.com/2006/04/metadata"}


class LabelTranslationGenerator(BaseTask):
    task_options = {
        "path": {"description": "Path to the translation file", "required": True}
    }

    def _run_task(self):

        with open(self.options["path"]) as translationFile:
            translationTree = ET.parse(translationFile)

        self.translate_labels(translationTree)
        self.translate_apps(translationTree)

        translationTree.write(
            self.options["path"],
            encoding="utf-8",
            xml_declaration=True,
            pretty_print=True,
        )

    def translate_apps(self, translationTree):

        appPath = Path("unpackaged", "post", "src", "applications")

        for app in appPath.glob("*.app"):
            with app.open() as appFile:
                appTree = ET.parse(appFile).getroot()
                customAppTag = ET.Element("customApplications")

                nameTag = ET.SubElement(customAppTag, "name")
                nameTag.text = app.stem

                labelTag = ET.SubElement(customAppTag, "label")
                labelTag.text = (
                    "## "
                    + appTree.xpath("//ns:label", namespaces=MD_NS)[0].text
                    + " ##"
                )

                translationTree.getroot().append(customAppTag)

    def translate_labels(self, translationTree):

        with open("src/labels/CustomLabels.labels") as f:
            labelTree = ET.parse(f).getroot()

        for labelsElement in labelTree.xpath("//ns:labels", namespaces=MD_NS):
            customLabelsTag = ET.SubElement(translationTree.getroot(), "customLabels")
            nameTag = ET.SubElement(customLabelsTag, "name")
            nameTag.text = labelsElement.find("ns:fullName", namespaces=MD_NS).text
            labelTag = ET.SubElement(customLabelsTag, "label")
            labelTag.text = (
                "##" + labelsElement.find("ns:value", namespaces=MD_NS).text + "##"
            )
