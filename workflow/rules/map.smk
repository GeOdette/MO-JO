import os
import sys
from pathlib import Path

sys.path.insert(0, Path(workflow.basedir).parent.parent.as_posix())
from constants.common import *
rule get_map_cmds:
    input:
        ref=ref_g,
    output:
        temp(TEMP_DIR + "/map_cmds.txt"),
    run:
        map_cmds_(ref=ref_g)


rule index_ref:
    input:
        ref_g,
    output:
        expand(
            REF_DIR + "/{ref}.fasta.{ext}",
            ref=ref_genome_filename,
            ext=["amb", "ann", "bwt", "pac", "sa"],
        ),
    shell:
        "bwa index {input}"


rule bwa_map:
    input:
        ref=ref_g,
        map_cmds=TEMP_DIR + "/map_cmds.txt",
        trimmed_reads=expand(
            TRIMMED_OUT_DIR + "/trimmed_{sample}_{reads}.fastq.gz",
            sample=sample_name,
            reads=["R1", "R2"],
        ),
        indices=expand(
            REF_DIR + "/{ref}.fasta.{ext}",
            ref=ref_genome_filename,
            ext=["amb", "ann", "bwt", "pac", "sa"],
        ),
    output:
        sam_file=expand(
            str(BASE_DIR) + "/results/bam/aligned_{sample}.sam", sample=sample_name
        ),
        bam_output=expand(
            str(BASE_DIR) + "/results/bam/aligned_{sample}.bam", sample=sample_name
        ),
        sorted_bam_out_=expand(
            str(BASE_DIR) + "/results/bam/aligned_{sample}_sorted.bam",
            sample=sample_name,
        ),
        bai=expand(
            str(BASE_DIR) + "/results/bam/aligned_{sample}_sorted.bam.bai",
            sample=sample_name,
        ),
    log:
        "logs/bwa_map.log"
    params:
        extra_args="",
    shell:
        """
        while read -r cmd;do
        $cmd {params.extra_args} &>> {log}
        done < {input.map_cmds}
        for sam_ in {output.sam_file}; do
        bam_="${{sam_%.sam}}.bam"
        samtools view -Sb $sam_ -o $bam_
        done

        for bam_ in {output.bam_output}; do
        bam_out="${{bam_%.bam}}_sorted.bam"
        samtools sort $bam_ -o $bam_out && samtools index $bam_out
        done
        """


rule samtools_stats:
    input:
        sorted_bam_out_=expand(
            str(BASE_DIR) + "/results/bam/aligned_{sample}_sorted.bam",
            sample=sample_name,
        ),
    output:
        expand(
            str(BASE_DIR) + "/results/bam/aligned_{sample}_sorted_stats.txt",
            sample=sample_name,
        ),
    log:
        "logs/samtools_stats.log",
    shell:
        """
        for bam_ in {input.sorted_bam_out_};do
        stats_out_="${{bam_%.bam}}_stats.txt"
        samtools flagstat $bam_ > $stats_out_ 2>> {log}
        done
        """
