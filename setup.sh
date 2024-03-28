#!/bin/bash

# Create a conda environment for the pipeline
conda create -n NGS_pipeline python=3.8 -y

# Activate the environment
source activate NGS_pipeline

# Install Snakemake
conda install -c bioconda -c conda-forge snakemake -y

# Install FastQC
conda install -c bioconda fastqc -y

# Install FastP
conda install -c bioconda fastp -y

# Install BWA
conda install -c bioconda bwa -y

# Install Samtools
conda install -c bioconda samtools -y

# Install BCFtools
conda install -c bioconda bcftools -y

echo "Installation complete. Activate the conda environment with 'conda activate snakemake_pipeline' before running the pipeline."