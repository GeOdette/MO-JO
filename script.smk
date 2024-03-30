import sys
import os

sys.path.insert(0, Path(workflow.basedir))


include: "workflow/rules/download.smk"
include: "workflow/rules/fastqc.smk"


rule all:
    input:
        expand(base_dir + "/results/data/{file_name}", file_name=SAMPLES),
        expand(base_dir + "/results/ref/{file_name}", file_name=REF),
        expand(
            base_dir + "/results/fastqc_output/{sample}_fastqc.{ext}",
            sample=SAMPLES_f,
            ext=EXTENSIONS,
        ),
        base_dir + "/results/fastqc_output/all_summary_stats.txt",
