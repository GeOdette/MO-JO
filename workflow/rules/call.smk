import os
import sys
from pathlib import Path
sys.path.insert(0, Path(workflow.basedir).parent.parent.as_posix())
from constants.common import *

rule variant_call:
    input:
        ref=ref_g,
        sorted_bam_out_=expand(str(BASE_DIR) + "/results/bam/aligned_{sample}_sorted.bam", sample=sample_name),
        bai=expand(str(BASE_DIR) + "/results/bam/aligned_{sample}_sorted.bam.bai", sample=sample_name),
    output:
        expand(str(BASE_DIR) + "/results/variants/{sample}.raw.vcf", sample=sample_name)
    shell:
        """
        for sorted_bam in {input.sorted_bam_out_}; do
            sam_name=$(basename $sorted_bam | sed 's/^aligned_//' | sed 's/\\_sorted.bam$//')
            bai={BASE_DIR}/results/bam/aligned_${{sam_name}}_sorted.bam.bai
            vcf_file={BASE_DIR}/results/variants/${{sam_name}}.raw.vcf
            bcftools mpileup -Ou -f {input.ref} $sorted_bam | \
            bcftools call -mv -Ov -o $vcf_file
        done
        """
rule variant_filtering:
    input:
        vcf=expand(str(BASE_DIR) + "/results/variants/{sample}.raw.vcf",  sample=sample_name)
    output:
        vcf_filtered=expand(str(BASE_DIR) + "/results/variants/{sample}.filtered.vcf", sample=sample_name)
    params:
        quality_threshold="QUAL>20",
        depth_threshold="DP>10"
    shell:
        """
        for raw_vcf in {input.vcf}; do
        filtered_vcf=${{raw_vcf%.raw.vcf}}.filtered.vcf
        bcftools filter -Ov -o $filtered_vcf -i '{params.quality_threshold} && {params.depth_threshold}' $raw_vcf
        done
            """