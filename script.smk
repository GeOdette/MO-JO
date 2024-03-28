
include: "workflow/rules/download.smk"
include: "workflow/rules/fastqc.smk"


rule all:
    input:
        config["data_dir"] + "/ACBarrie_R1.fastq.gz",
        config["data_dir"] + "/ACBarrie_R2.fastq.gz",
        config["ref_dir"] + "/reference.fasta",
        output_dir=directory("results/fastqc_output/"),
        output_files=expand(
            "results/fastqc_output/{sample}_fastqc.{ext}",
            sample=SAMPLES,
            ext=EXTENSIONS,
        ),
        summary_stats="results/fastqc_output/all_summary_stats.txt",
