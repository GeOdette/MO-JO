import sys

sys.path.insert(0, Path(workflow.basedir))

include: "workflow/rules/download.smk"
include: "workflow/rules/fastqc.smk"
include: "workflow/rules/trim.smk"
# include: "workflow/rules/common.smk"


rule all:
    input:
        expand(DATA_DIR + "/{file_name}", file_name=SAMPLES),
        expand(REF_DIR + "/{file_name}", file_name=REF),
        expand(FASTQC_DIR + "/{sample}_fastqc.{ext}",
            sample=SAMPLES_f,
            ext=EXTENSIONS,
        ),
        FASTQC_DIR + "/all_summary_stats.txt",
        expand(TRIMMED_OUT_DIR + "/{sample}_1_trimmed_fastq.gz", sample=sample_name),
        expand(TRIMMED_OUT_DIR + "/{sample}_2_trimmed_fastq.gz", sample=sample_name),
        expand(TRIMMED_OUT_DIRfq  + "/{sample}_1_trimmed_fastq_fastqc.html", sample=sample_name),
        expand(TRIMMED_OUT_DIRfq + "/{sample}_2_trimmed_fastq_fastqc.zip", sample=sample_name),
        directory(TRIMMED_OUT_DIRfq)