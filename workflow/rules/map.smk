import os
import sys
from pathlib import Path
sys.path.insert(0, Path(workflow.basedir).parent.parent.as_posix())
from constants.common import *
rule index_ref:
    input:
        ref_g
    output:
        expand(REF_DIR + "/{ref}.{ext}", ref="Reference.fasta", ext=['amb', 'ann', 'bwt', 'pac', 'sa'])
    shell:
        "bwa index {input}"
# def get_bwa_cmd():
#     bwa_cmds = []  
#     read1_files = [file for file in getInputFiles() if file.endswith("_1.fastq.gz")]
#     for read1 in read1_files:
#         read2 = read1.replace("_1.fastq.gz", "_2.fastq.gz")  
#         bwa_cmd_ = f"bwa mem {ref} {read1} {read2}"
#         bwa_cmds.append(bwa_cmd_) 
#     return bwa_cmds
# print(*get_bwa_cmd())


rule bwa_map:
    input:
        ref=ref_g,
        reads=expand(TRIMMED_OUT_DIR + "/{sample}_{read}_trimmed_fastq.gz", sample=sample_name, read=['1', '2'])
        
    output:
        sam_file=str(BASE_DIR) + "/results/bam/aligned_{sample}.sam",
        bam_output=str(BASE_DIR) + "/results/bam/aligned_{sample}.bam",
        sorted_bam_out_=str(BASE_DIR) + "/results/bam/alined_sorted_{sample}.bam",
        bai=str(BASE_DIR) + "/results/bam/alined_sorted_{sample}.bam.bai"
    shell:
        """
        bwa mem {input.ref} {input.reads[0]} {input.reads[1]} > {output.sam_file}
        samtools view -Sb {output.sam_file} -b > {output.bam_output}
        samtools sort {output.bam_output} -o {output.sorted_bam_out_}
        samtools index {output.sorted_bam_out_}
        """
