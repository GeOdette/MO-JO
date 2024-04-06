import os
import sys
from pathlib import Path
sys.path.insert(0, Path(workflow.basedir).parent.parent.as_posix())
from constants.common import *

rule variant_call:
    input:
        ref=ref_g,
        sorted_bam_out_=expand(
            str(BASE_DIR) + "/results/bam/aligned_{sample}_sorted.bam",
            sample=sample_name,
        ),
        bai=expand(
            str(BASE_DIR) + "/results/bam/aligned_{sample}_sorted.bam.bai",
            sample=sample_name,
        ),
    output:
        expand(str(BASE_DIR) + "/results/variants/bcf/{sample}.raw.vcf", sample=sample_name),
    log:
        "logs/bcfvariants.log"
    shell:
        """
        for sorted_bam in {input.sorted_bam_out_}; do
            sam_name=$(basename $sorted_bam | sed 's/^aligned_//' | sed 's/\\_sorted.bam$//')
            bai={BASE_DIR}/results/bam/aligned_${{sam_name}}_sorted.bam.bai
            vcf_file={BASE_DIR}/results/variants/bcf//${{sam_name}}.raw.vcf
            bcftools mpileup -Ou -f {input.ref} $sorted_bam | \
            bcftools call -mv -Ov -o $vcf_file &>> {log}
        done
        """


rule variant_filtering:
    input:
        vcf=expand(
            str(BASE_DIR) + "/results/variants/bcf/{sample}.raw.vcf", sample=sample_name
        ),
    output:
        vcf_filtered=expand(
            str(BASE_DIR) + "/results/variants/bcf/{sample}.filtered.vcf",
            sample=sample_name,
        ),
    params:
        quality_threshold="QUAL>20",
        depth_threshold="DP>10",
    shell:
        """
        for raw_vcf in {input.vcf}; do
        filtered_vcf=${{raw_vcf%.raw.vcf}}.filtered.vcf
        bcftools filter -Ov -o $filtered_vcf -i '{params.quality_threshold} && {params.depth_threshold}' $raw_vcf
        done
            """

rule bcftools_stats:
    input:
        vcf_filtered=expand(
            str(BASE_DIR) + "/results/variants/bcf/{sample}.filtered.vcf",
            sample=sample_name,
        ),
        vcf_raw=expand(str(BASE_DIR) + "/results/variants/bcf/{sample}.raw.vcf", sample=sample_name),
    output:
        expand(
            str(BASE_DIR) + "/results/variants/bcf/{sample}.filtered_stats.txt",
            sample=sample_name,
        ),
        expand(
            str(BASE_DIR) + "/results/variants/bcf/{sample}.raw_stats.txt",
            sample=sample_name,
        ),
    log:
        "logs/bcftools_stats.log",
    shell:
        """
        for vcf_ in {input.vcf_filtered};do
        filtered_stats_out_="${{vcf_%.vcf}}_stats.txt"
        raw_stats_out_="${{vcf_%.filtered.vcf}}.raw_stats.txt"
        bcftools stats $vcf_ > $filtered_stats_out_ 2>> {log}
        raw_vcf_="${{vcf_%.filtered.vcf}}.raw.vcf"
        bcftools stats $raw_vcf_ > $raw_stats_out_ 2>> {log}
        done
        """
