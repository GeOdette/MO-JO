import os
import sys
from pathlib import Path

sys.path.insert(0, Path(workflow.basedir).parent.parent.as_posix())
from constants.common import *


configfile: "config/config.yaml"
rule download_dataset:
    output:
        expand(base_dir + "/results/data/{file_name}", file_name=SAMPLES),
        expand(base_dir + "/results/ref/{file_name}", file_name=REF),
    threads: config["cores"]["download_dataset"]
    run:
        urls = getFileUrls(urls_df=urls_df)
        for file_name, file_url in urls.items():
            if file_name.endswith(".fastq.gz"):
                output_dir = "results/data"
            elif file_name.endswith(".fasta"):
                output_dir = "results/ref"
            shell(f"wget -O {output_dir}/{file_name} {file_url}")
