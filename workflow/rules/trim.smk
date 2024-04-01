
sys.path.insert(0, Path(workflow.basedir).parent.parent.as_posix())
from constants.common import *
rule fastp:
    input:
        r1 = expand(DATA_DIR + "/{sample}_1.fastq.gz", sample=sample_name),
        r2 = expand(DATA_DIR + "/{sample}_2.fastq.gz", sample=sample_name)
    output:
        r1_out = expand(TRIMMED_OUT_DIR + "/{sample}_1_trimmed_fastq.gz", sample=sample_name),
        r2_out = expand(TRIMMED_OUT_DIR + "/{sample}_2_trimmed_fastq.gz", sample=sample_name),
        json = os.path.join(TRIMMED_OUT_DIR, "fastp.json"),
        html = os.path.join(TRIMMED_OUT_DIR, "fastp.html")

    params:
        tr_dir=str(TRIMMED_OUT_DIR)

    shell:
        """
        mkdir -p {params.tr_dir}
        fastp -i {input.r1} -o {output.r1_out} -I {input.r2} -O {output.r2_out} -j {output.json} -h {output.html}
        """

rule fastqc_after_fastp:
    output:
        expand(TRIMMED_OUT_DIRfq  + "/{sample}_{read}_trimmed_fastq_fastqc.{ext}", sample=sample_name, ext=['html', 'zip'], read=['1', '2'])
        
    input:
        expand(TRIMMED_OUT_DIR + "/{sample}_{read}_trimmed_fastq.gz", sample=sample_name, read=['1','2']),
    params:
        TRIMMED_OUT_DIRfq
    shell:
        """
        mkdir -p {params}
        fastqc {input} -o {params}
        """
