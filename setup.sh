#!/bin/bash

conda install -n base -c conda-forge mamba

mamba create -c conda-forge -c bioconda -n NGS_P snakemake

conda activate NGS_P

conda install bioconda::fastqc -y

mamba install fastp -y

conda install bioconda::bwa -y

conda install bioconda::samtools -y

conda install bioconda::bcftools -y

conda install bioconda::multiqc -y

sudo apt-get install pandoc

# Installing additional dependencies
pip install snakemake-wrapper-utils

echo "Installation complete. Activate the conda environment with 'conda activate NGS_p' before running the pipeline."