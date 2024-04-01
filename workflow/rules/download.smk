import os
import sys
from pathlib import Path

sys.path.insert(0, Path(workflow.basedir).parent.parent.as_posix())
from constants.common import *
reads_url = [url for url in urls_df.tolist() if ".fastq.gz" in url]
ref_url = [url for url in urls_df.tolist() if ".fasta" in url]

configfile: "config/config.yaml"
rule download:
    output:
        reads_out=expand(DATA_DIR + "/{file_name}", file_name=SAMPLES),
        ref_out=expand(REF_DIR + "/{file_name}", file_name=REF),
    params:
        reads_url=reads_url,
        ref_url=ref_url
    shell: '/home/odette/NGS_pipeline/workflow/scripts/download.sh'

