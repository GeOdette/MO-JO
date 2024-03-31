import sys
from pathlib import Path
import os
sys.path.insert(0, str(Path(workflow.basedir).parent.parent))
from constants.common import *

def get_all_output(wildcards):
    targets = []
    targets += expand(FASTQC_DIR, "/{sample}_fastqc.html", sample=SAMPLES_f)
    targets += expand(FASTQC_DIR, "/{sample}_fastqc.zip", sample=SAMPLES_f)
    targets += expand(DATA_DIR, "/{file_name}", file_name=SAMPLES)
    targets += expand(REF_DIR, "/{file_name}", file_name=REF)
    targets += os.path.join(FASTQC_DIR, "all_summary_stats.txt")
    targets += expand(base_dir + "/trimmed/{sample}_1_trimmed.fastq.gz", sample=sample_name)
    targets += expand(base_dir + "/trimmed/{sample}_2_trimmed.fastq.gz", sample=sample_name)
    return targets