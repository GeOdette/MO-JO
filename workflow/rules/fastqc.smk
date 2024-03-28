import os
import glob
import sys
from pathlib import Path

sys.path.insert(0, Path(workflow.basedir).parent.parent.as_posix())
from constants.common import *


EXTENSIONS = ["zip", "html"]
SAMPLES = getSampleNames("results/data/")


rule fastqc:
    output:
        output_dir=directory("results/fastqc_output/"),
        output_files=expand(
            "results/fastqc_output/{sample}_fastqc.{ext}",
            sample=SAMPLES,
            ext=EXTENSIONS,
        ),
    input:
        *getInputFiles("results/data/", "fastq.gz"),
    shell:
        """
        mkdir -p {output.output_dir}
        fastqc {input} -o {output.output_dir}
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
