import os
import sys
from pathlib import Path
sys.path.insert(0, Path(workflow.basedir))
from constants.common import *
configfile: 'config/config.yaml'
include: "workflow/rules/download.smk"
include: "workflow/rules/fastqc.smk"
include: "workflow/rules/trim.smk"
include: "workflow/rules/map.smk"
include: "workflow/rules/call.smk"
include: "workflow/rules/multiqc.smk"
# ruleorder: download > fastqc > unzip_fastqc_files > fastp > fastqc_after_fastp > index_ref > bwa_map > variant_call > variant_filtering

rule all:
    input:
        report(
            str(BASE_DIR) + "/results/multiqc/multiqc_report.html",
            caption="report/multiqc.rst",
            category="Quality control",
        ),