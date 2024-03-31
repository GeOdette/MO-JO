import pandas as pd
from common import *
def prepare_samples_csv():
     fq1 = [sample for sample in getInputFiles(DATA_DIR, ".fastq.gz") if sample.endswith("_1.fastq.gz")]
     fq2 = [sample for sample in getInputFiles(DATA_DIR, ".fastq.gz") if sample.endswith("_2.fastq.gz")]
     sample_data = {
        "sample" : sample_names_list,
        "fastq1" : fq1,
        "fastq2" : fq2
    }
     sample_table_df = pd.DataFrame(sample_data)
     sample_csv = os.path.join(BASE_DIR, "samples.csv")
     sample_table_df.to_csv(sample_csv, index=False)
     return sample_table_df
print(prepare_samples_csv())