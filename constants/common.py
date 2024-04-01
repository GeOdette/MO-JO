import os
import sys
from pathlib import Path
import glob
import pandas as pd

BASE_DIR = Path(__file__).resolve().parent.parent
# Creating needed dirs
os.makedirs(os.path.join(BASE_DIR, 'results/data'), exist_ok=True)
os.makedirs(os.path.join(BASE_DIR, 'results/ref'), exist_ok=True)
# os.makedirs(os.path.join(BASE_DIR, 'results/fastqc_output/'), exist_ok=True)
base_dir = str(BASE_DIR)
DATA_DIR = os.path.join(BASE_DIR, "results", "data")
FASTQC_DIR = os.path.join(BASE_DIR, "results", "fastqc_output")
REF_DIR = os.path.join(BASE_DIR, "results", "ref")
TRIMMED_OUT_DIR = os.path.join(BASE_DIR, "results", "trimmed")
TRIMMED_OUT_DIRfq = os.path.join(BASE_DIR, "results", "trimmed", "fastqc_out")
fq_df = pd.read_csv(os.path.join(BASE_DIR, "links.csv"), header=None)
urls_df = fq_df.iloc[:, 0]
file_names = []
for url in urls_df:
    file_name = url.split("/")[-1].split("?")[0]
    file_names.append(file_name)
SAMPLES = [name for name in file_names if name.endswith(".fastq.gz")]
REF = [name for name in file_names if name.endswith(".fasta")]
def getInputFiles(ext="fastq.gz"):
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