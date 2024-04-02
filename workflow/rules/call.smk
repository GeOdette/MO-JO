import os
import sys
from pathlib import Path
sys.path.insert(0, Path(workflow.basedir).parent.parent.as_posix())
from constants.common import *

rule variant_call:
    input:
        ref=ref_g,
        sorted_bam_out_=str(BASE_DIR) + "/results/bam/alined_sorted_{sample}.bam",
        bai=str(BASE_DIR) + "/results/bam/alined_sorted_{sample}.bam.bai"
    output:
        vcf=str(BASE_DIR) + "/results/variants/{sample}.raw.vcf"
    shell:
        """
        bcftools mpileup -Ou -f {input.ref} {input.sorted_bam_out_} | \
        bcftools call -mv -Ov -o {output.vcf}
        """
rule variant_filtering:
    input:
        vcf=str(BASE_DIR) + "/results/variants/{sample}.raw.vcf"
    output:
        vcf_filtered=str(BASE_DIR) + "/results/variants/{sample}.filtered.vcf"
    params:
        quality_threshold="QUAL>20",
        depth_threshold="DP>10"
    shell:
        """
        bcftools filter -Ov -o {output.vcf_filtered} -i '{params.quality_threshold} && {params.depth_threshold}' {input.vcf}
        """