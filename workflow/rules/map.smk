import os
import sys
from pathlib import Path
sys.path.insert(0, Path(workflow.basedir).parent.parent.as_posix())
from constants.common import *

rule index_ref:
    input:
        [os.path.join(REF_DIR, ref) for ref in REF]
    output:
        expand(REF_DIR + "/{ref}.{ext}", ref=REF, ext=['amb', 'ann', 'bwt', 'pac', 'sa'])
    shell:
        "bwa index {input}"

rule bwa_map:
    input:
        ref= [os.path.join(REF_DIR, ref) for ref in REF],
        reads=expand(TRIMMED_OUT_DIR + "/{sample}_{read}_trimmed_fastq.gz", sample=sample_name, read=['1', '2'])
        
    output:
        sam_file=expand(str(BASE_DIR) + "/results/bam/aligned_{sample}.sam", sample=sample_name),
        bam_output=expand(str(BASE_DIR) + "/results/bam/aligned_{sample}.bam", sample=sample_name)
    shell:
        """
        bwa mem {input.ref} {input.reads[0]} {input.reads[1]} > {output.sam_file}
        samtools view -Sb {output.sam_file} -b > {output.bam_output}
        """