import sys

sys.path.insert(0, Path(workflow.basedir))
from constants.common import *
configfile: 'config/config.yaml'
include: "workflow/rules/download.smk"
include: "workflow/rules/fastqc.smk"
include: "workflow/rules/trim.smk"
include: "workflow/rules/map.smk"
include: "workflow/rules/call.smk"
ruleorder: download > fastqc > unzip_fastqc_files > fastp > fastqc_after_fastp > index_ref > bwa_map > variant_call > variant_filtering
fastqc_out = [
        expand(["{fastqc_dir}/{sample}_fastqc.html", "{fastqc_dir}/{sample}_fastqc.zip"], fastqc_dir=FASTQC_DIR, sample=SAMPLES_f)
]
trimming_out = [
    expand(TRIMMED_OUT_DIR + "/trimmed_{sample}_{reads}.fastq.gz", sample=sample_name, reads=['R1', 'R2']),
    
]
trimmingfq_out = [
        expand(TRIMMED_OUT_DIRfq  + "/trimmed_{sample}_{reads}_fastqc.{ext}", sample=sample_name, ext=['html', 'zip'], reads=['R1', 'R2'])

]
map_out = [
      expand(str(BASE_DIR) + "/results/bam/aligned_{sample}.sam", sample=sample_name),
      expand(str(BASE_DIR) + "/results/bam/aligned_{sample}_sorted.bam", sample=sample_name),
      expand(str(BASE_DIR) + "/results/bam/aligned_{sample}_sorted.bam.bai", sample=sample_name),
]
vcf_call_out = [
            expand([str(BASE_DIR) + "/results/variants/{sample}.filtered.vcf", str(BASE_DIR) + "/results/variants/{sample}.raw.vcf"],sample=sample_name)
]


rule all:
    input:
        fastqc_out,
        getInputFiles(),
        FASTQC_DIR + "/all_summary_stats.txt",
        ref_g,
        trimming_out,
        trimmingfq_out,
        expand(REF_DIR + "/{ref}.fasta.{ext}", ref=ref_genome_filename, ext=['amb', 'ann', 'bwt', 'pac', 'sa']),
        map_out,
        vcf_call_out