#!/bin/bash

conda install -c conda-forge mamba -y

mamba install -c conda-forge -c bioconda snakemake -y

conda install bioconda::fastqc -y

mamba install -c bioconda fastp -y

conda install bioconda::bwa -y

conda install  bioconda::samtools -y

conda install bioconda::bcftools -y

conda install mojo bioconda::multiqc -y

sudo apt-get install pandoc

pip install snakemake-wrapper-utils

echo "Installation complete."