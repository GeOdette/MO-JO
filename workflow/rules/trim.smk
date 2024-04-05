
sys.path.insert(0, Path(workflow.basedir).parent.parent.as_posix())
from constants.common import *
configfile: 'config/config.yaml'
rule get_fastp_cmds:
    output:
        TEMP_DIR + "/fastp_cmds.txt"
    run:
        fastp_cmds_()
rule fastp:
    input:
        fastp_cmds = TEMP_DIR + "/fastp_cmds.txt",
        read_files=expand(DATA_DIR + "/{sample}_{reads}.fastq.gz", sample=sample_name, reads=['R1', 'R2']),
        qc1=expand(["{fastqc_dir}/{sample}_fastqc.html", "{fastqc_dir}/{sample}_fastqc.zip"], fastqc_dir=FASTQC_DIR, sample=SAMPLES_f)
    output:
        expand(TRIMMED_OUT_DIR + "/trimmed_{sample}_{reads}.fastq.gz", sample=sample_name, reads=['R1', 'R2']),
        json = os.path.join(TRIMMED_OUT_DIR, "fastp.json"),
        html = os.path.join(TRIMMED_OUT_DIR, "fastp.html")

    params:
        trim_dir=str(TRIMMED_OUT_DIR),
        extras=config["params"]["fastp"]["extra_args"]

    shell:
        """
        mkdir -p {params.trim_dir}
        while read -r cmd;do
        $cmd -j {output.json} -h {output.html} {params.extras}
        done < {input.fastp_cmds}
        """

rule fastqc_after_fastp:
    output:
        expand(TRIMMED_OUT_DIRfq  + "/trimmed_{sample}_{reads}_fastqc.{ext}", sample=sample_name, ext=['html', 'zip'], reads=['R1', 'R2'])
        
    input:
        expand(TRIMMED_OUT_DIR + "/trimmed_{sample}_{reads}.fastq.gz", sample=sample_name, reads=['R1', 'R2']),
    params:
        trim_out=TRIMMED_OUT_DIRfq,
    shell:
        """
        mkdir -p {params.trim_out}
        fastqc {input} -o {params}
        """
