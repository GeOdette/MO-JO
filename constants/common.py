import os
import sys
from pathlib import Path
import glob
import pandas as pd

BASE_DIR = Path(__file__).resolve().parent.parent
df = pd.read_csv(os.path.join(BASE_DIR, "links.csv"), header=None)
urls_df = df.iloc[:, 0]
file_names = []
for url in urls_df:
    file_name = url.split("/")[-1].split("?")[0]
    file_names.append(file_name)

def getInputFiles(input_dir: str, ext: str):
    list_of_files = []
    for file in os.listdir(input_dir):
        if file.endswith(ext):
            list_of_files.append(os.path.join(BASE_DIR, input_dir, file))
    return list_of_files


def getSampleNames(input_dir: str):
    sample_names = []
    for file in os.listdir(input_dir):
        files_with_ext = os.path.basename(file)
        if files_with_ext.endswith(".fastq.gz"):
            sample_names.append(os.path.splitext(files_with_ext)[0][:-6])
        else:
            sample_names.append(os.path.splitext(files_with_ext)[0])
    return sample_names


def getFileUrls(urls_df):
    file_urls = {}
    for url in urls_df:
        file_name = url.split("/")[-1].split("?")[0]
        file_urls[file_name] = url
    return file_urls

