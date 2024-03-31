
sys.path.insert(0, Path(workflow.basedir).parent.parent.as_posix())
from constants.common import *
# import pandas as pd
# sample_csv = os.path.join(BASE_DIR, "samples.csv")
# sample_table = pd.read_csv(sample_csv).set_index('sample', drop=False)
# def get_fq1(sample_name:str):
#     return sample_table.loc[sample_table['sample'] == sample_name, 'fastq1'].values[0],
# def get_fq2(sample_name:str):
#     return sample_table.loc[sample_table['sample'] == sample_name, 'fastq1'].values[0],
# def get_fq_files_dict(sample_name:str):
#     paired_end_reads = {}
#     for read in getInputFiles(DATA_DIR, "fastq.gz"):
#         paired_end_reads["r1"] = sample_table.loc[sample_table['sample'] == sample_name, 'fastq1'].values[0]
#         paired_end_reads["r2"] = sample_table.loc[sample_table['sample'] == sample_name, 'fastq2'].values[0]
#     return paired_end_reads

# rule all:
#     input:
#         expand(TRIMMED_OUT_DIR + "/{sample}_1_trimmed_fastq.gz", sample=sample_name),
#         expand(TRIMMED_OUT_DIR + "/{sample}_2_trimmed_fastq.gz", sample=sample_name),
#         expand(TRIMMED_OUT_DIRfq  + "/{sample}_1_trimmed_fastq_fastqc.html", sample=sample_name),
#         expand(TRIMMED_OUT_DIRfq + "/{sample}_2_trimmed_fastq_fastqc.zip", sample=sample_name),
#         directory(TRIMMED_OUT_DIRfq)

rule fastp:
    input:
        r1 = expand(DATA_DIR + "/{sample}", sample=SAMPLES),
        r2 = expand(DATA_DIR + "/{sample}", sample=SAMPLES)
    output:
        r1_out = expand(TRIMMED_OUT_DIR + "/{sample}_1_trimmed_fastq.gz", sample=sample_name),
        r2_out = expand(TRIMMED_OUT_DIR + "/{sample}_2_trimmed_fastq.gz", sample=sample_name)
    shell:
        """
        fastp -i {input.r1} -o {output.r1_out} -I {input.r2} -O {output.r2_out}
        """

rule fastqc_after_fastp:
    output:
        html = expand(TRIMMED_OUT_DIRfq  + "/{sample}_1_trimmed_fastq_fastqc.html", sample=sample_name),
        zip_f = expand(TRIMMED_OUT_DIRfq + "/{sample}_2_trimmed_fastq_fastqc.zip", sample=sample_name),
        fp_fq_our_dir = directory(TRIMMED_OUT_DIRfq)
        
    input:
        expand(TRIMMED_OUT_DIR + "/{sample}_1_trimmed_fastq.gz", sample=sample_name),
        expand(TRIMMED_OUT_DIR + "/{sample}_2_trimmed_fastq.gz", sample=sample_name)
    shell:
        """
        mkdir -p {output.fp_fq_our_dir}
        fastqc {input} -o {output.fp_fq_our_dir}
        """
