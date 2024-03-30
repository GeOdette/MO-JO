import os
import glob
import sys
from pathlib import Path

sys.path.insert(0, Path(workflow.basedir).parent.parent.as_posix())
from constants.common import *
EXTENSIONS = ["zip", "html"]
rule fastqc:
    output:
        expand(
            base_dir + "/results/fastqc_output/{sample}_fastqc.{ext}",
            sample=SAMPLES_f,
            ext=EXTENSIONS,
        ),
    input:
        *getInputFiles("results/data", "fastq.gz"),
    params:
        fastqc_output= base_dir + "/results/fastqc_output",
    shell:
        """
        fastqc {input} -o {params.fastqc_output}
        """

rule unzip_fastqc_files:
    output:
        summary_stats="results/fastqc_output/all_summary_stats.txt",
    input:
        input_files=expand(
            "results/fastqc_output/{sample}_fastqc.{ext}",
            sample=SAMPLES,
            ext=["zip"],
        ),
    shell:
        """
        for zip_file in {input.input_files}; do
        unzip_dir=results/fastqc_output
        unzip "$zip_file" -d $unzip_dir
        cat "$unzip_dir/$(basename $zip_file '.zip')/summary.txt" >> {output.summary_stats}
        rm -r "$unzip_dir/$(basename $zip_file '.zip')"
        done
        """