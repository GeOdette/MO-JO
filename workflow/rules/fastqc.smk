import os
import glob
import sys
from pathlib import Path
sys.path.insert(0, Path(workflow.basedir).parent.parent.as_posix())
from constants.common import *
EXTENSIONS = ["zip", "html"]
rule fastqc:
    output:
        expand( [
            FASTQC_DIR + "/{sample}_fastqc.html",
            FASTQC_DIR + "/{sample}_fastqc.zip",

        ],sample=SAMPLES_f,

        )
    input:
        *getInputFiles(DATA_DIR, "fastq.gz"),
    params:
        FASTQC_DIR 
    shell:
        """
        fastqc {input} -o {params}
        """

rule unzip_fastqc_files:
    output:
        summary_stats=FASTQC_DIR + "/all_summary_stats.txt",
    input:
        input_files=expand(
            FASTQC_DIR + "/{sample}_fastqc.{ext}",
            sample=SAMPLES_f,
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