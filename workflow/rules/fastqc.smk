import os
import sys
from pathlib import Path
sys.path.insert(0, Path(workflow.basedir).parent.parent.as_posix())
from constants.common import *
EXTENSIONS = ["zip", "html"]
rule fastqc:
    output:
        expand(FASTQC_DIR + "/{sample}_fastqc.html", sample=SAMPLES_f),
        expand(FASTQC_DIR + "/{sample}_fastqc.zip", sample=SAMPLES_f),
        directory(FASTQC_DIR)
    input:
        *getInputFiles()
    params:
        fq_dir=str(FASTQC_DIR),
    shell:
        """
        mkdir -p {params.fq_dir}
        fastqc {input} -o {params.fq_dir}
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