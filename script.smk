import sys

sys.path.insert(0, Path(workflow.basedir))
from constants.common import *
include: "workflow/rules/download.smk"
include: "workflow/rules/fastqc.smk"
include: "workflow/rules/trim.smk"
include: "workflow/rules/map.smk"
include: "workflow/rules/call.smk"

fastqc_out = [
            expand(["{fastqc_dir}/{sample}_fastqc.html", "{fastqc_dir}/{sample}_fastqc.zip"], fastqc_dir=FASTQC_DIR, sample=SAMPLES_f)
]
trimming_out = [
    expand([TRIMMED_OUT_DIR + "/{sample}_{read}_trimmed_fastq.gz"], read=['1','2'], sample=sample_name)
]
trimmingfq_out = [
    expand(TRIMMED_OUT_DIRfq  + "/{sample}_{read}_trimmed_fastq_fastqc.{ext}", sample=sample_name, ext=['html', 'zip'], read=['1', '2'])

]
map_out = [
    expand(str(BASE_DIR) + "/results/bam/aligned_{sample}.sam", sample=sample_name),
    expand(str(BASE_DIR) + "/results/bam/aligned_{sample}.bam", sample=sample_name),
    expand(str(BASE_DIR) + "/results/bam/alined_sorted_{sample}.bam", sample=sample_name),
    expand(str(BASE_DIR) + "/results/bam/alined_sorted_{sample}.bam.bai", sample=sample_name)
]
vcf_call_out = [
            expand([str(BASE_DIR) + "/results/variants/{sample}.filtered.vcf", str(BASE_DIR) + "/results/variants/{sample}.raw.vcf"],sample=sample_name)
]


rule all:
    input:
        fastqc_out,
        getInputFiles(),
        FASTQC_DIR + "/all_summary_stats.txt",
        expand(REF_DIR + "/{file_name}", file_name=REF),
        trimming_out,
        trimmingfq_out,
        expand(REF_DIR + "/{ref}.{ext}", ref="Reference.fasta", ext=['amb', 'ann', 'bwt', 'pac', 'sa']),
        map_out,
        vcf_call_out