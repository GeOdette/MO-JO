import os
import sys
from pathlib import Path
sys.path.insert(0, Path(workflow.basedir).parent.parent.as_posix())
from constants.common import *
rule multiqc:
    input:
        expand(
            ["{fastqc_dir}/{sample}_fastqc.html", "{fastqc_dir}/{sample}_fastqc.zip"],
            fastqc_dir=FASTQC_DIR,
            sample=SAMPLES_f,
        ),
        expand(
            TRIMMED_OUT_DIR + "/trimmed_{sample}_{reads}.fastq.gz",
            sample=sample_name,
            reads=["R1", "R2"],
        ),
        expand(
            TRIMMED_OUT_DIRfq + "/trimmed_{sample}_{reads}_fastqc.{ext}",
            sample=sample_name,
            ext=["html", "zip"],
            reads=["R1", "R2"],
        ),
        expand(
            str(BASE_DIR) + "/results/bam/aligned_{sample}_sorted_stats.txt",
            sample=sample_name,
        ),
        expand(
            str(BASE_DIR) + "/results/variants/bcf/{sample}.filtered_stats.txt",
            sample=sample_name,
        ),
        expand(
            str(BASE_DIR) + "/results/variants/bcf/{sample}.raw_stats.txt",
            sample=sample_name,
        ),
        str(FASTQC_DIR) + "/all_summary_stats.txt",
    output:
       report(
            str(BASE_DIR) + "/results/multiqc/multiqc_report.html",
            caption="report/multiqc.rst",
            category="Quality control",
        ),
        directory("results/multiqc/multiqc_data"),
    log:
        "logs/multiqc.log",
    params:
        outdir = "results/multiqc",
    shell:
        """
        multiqc --force --outdir {params.outdir} {input}
        """