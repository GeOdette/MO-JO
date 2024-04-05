import os
import sys
from pathlib import Path
import pandas as pd
import re

BASE_DIR = Path(__file__).resolve().parent.parent
# Creating needed dirs
os.makedirs(os.path.join(BASE_DIR, 'results/data'), exist_ok=True)
os.makedirs(os.path.join(BASE_DIR, 'results/ref'), exist_ok=True)
os.makedirs(os.path.join(BASE_DIR, 'temp'), exist_ok=True)
# os.makedirs(os.path.join(BASE_DIR, 'results/fastqc_output/'), exist_ok=True)
base_dir = str(BASE_DIR)
DATA_DIR = os.path.join(BASE_DIR, "results", "data")
FASTQC_DIR = os.path.join(BASE_DIR, "results", "fastqc_output")
REF_DIR = os.path.join(BASE_DIR, "results", "ref")
TRIMMED_OUT_DIR = os.path.join(BASE_DIR, "results", "trimmed")
TRIMMED_OUT_DIRfq = os.path.join(BASE_DIR, "results", "trimmed", "fastqc_out")
TEMP_DIR = os.path.join(BASE_DIR, 'temp')

fq_df = pd.read_csv(os.path.join(BASE_DIR, "links.txt"), header=None)
urls_df = fq_df.iloc[:, 0]
file_names = []
for url in urls_df:
    file_name = url.split("/")[-1].split("?")[0]
    if file_name.endswith("_1.fastq.gz"):
        f_name = file_name.replace("_1.fastq.gz", "_R1.fastq.gz")
    elif file_name.endswith("_2.fastq.gz"):
        f_name = file_name.replace("_2.fastq.gz", "_R2.fastq.gz")
    else:
        f_name = file_name
    file_names.append(f_name)
SAMPLES = [name for name in file_names if name.endswith(".fastq.gz")]
REF = [name for name in file_names if name.endswith(".fasta")]
def is_reference_genome(file_names):
    valid_extensions = (".fasta", ".fna", ".fna.gz", ".fa")
    fasta_files = [file for file in file_names if file.endswith(valid_extensions)]
    if fasta_files:
        return fasta_files[0]
    else:
        return None

ref_genome_filename = is_reference_genome(file_names)

if ref_genome_filename:
    ref_g = os.path.join(REF_DIR, ref_genome_filename)
else:
    ref_g = None
def extract_ref_basename(filename):
    pattern = re.compile(r'(.+)\.(fasta|fna|fa\.gz|fna\.gz)$')
    match = pattern.match(filename)
    if match:
        base_name=match.group(1)
        return base_name
    else:
        return filename
ref_genome_filename = os.path.basename(extract_ref_basename(ref_g))

def getInputFiles(ext=".fastq.gz"):
    list_of_files = []
    for file in file_names:
        if ext in file:
            list_of_files.append(os.path.join(DATA_DIR, file))
    return list_of_files

def getSampleNames():
    sample_names = []
    for file in getInputFiles():
        files_with_ext = os.path.basename(file)
        if files_with_ext.endswith(".fastq.gz"):
            sample_names.append(os.path.splitext(files_with_ext)[0][:-6])
        else:
            sample_names.append(os.path.splitext(files_with_ext)[0])
    return sample_names

SAMPLES_f = getSampleNames()
sample_names_list = list(set([sample.split('_')[0] for sample in getSampleNames()]))
sample_name = [name for name in sample_names_list]
def getFileUrls(urls_df):
    file_urls = {}
    for url in urls_df:
        file_name = url.split("/")[-1].split("?")[0]
        file_urls[file_name] = url
    return file_urls
def fastp_cmds_():
    fastp_cmds_text=os.path.join(TEMP_DIR, "fastp_cmds.txt")
    with open(fastp_cmds_text, 'w') as f:
        for name in sample_name:
            read1 = os.path.join(BASE_DIR, 'results', 'data', f"{name}_R1.fastq.gz")
            read1_out=os.path.join(BASE_DIR, 'results', 'trimmed', f"trimmed_{name}_R1.fastq.gz")
            read2 = read1.replace("_R1.fastq.gz", "_R2.fastq.gz")
            read2_out=read1_out.replace("_R1.fastq.gz", "_R2.fastq.gz")
            fastp_cmds = f"fastp -i {read1} -o {read1_out} -I {read2} -O {read2_out}\n"
            f.write(fastp_cmds)
def map_cmds_(ref:str):
    map_cmds_text=os.path.join(TEMP_DIR, "map_cmds.txt")
    with open(map_cmds_text, 'w') as f:
        for name in sample_name:
            read1 = os.path.join(BASE_DIR, 'results', 'trimmed', f"trimmed_{name}_R1.fastq.gz")
            read2 = read1.replace("_R1.fastq.gz", "_R2.fastq.gz")
            _out=os.path.join(BASE_DIR, 'results', 'bam', f"aligned_{name}.sam")
            map_cmds = f"bwa mem {ref} {read1} {read2} -o {_out}\n"
            f.write(map_cmds)