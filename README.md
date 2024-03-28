#THE NGS PIPELINE
This pipeline is a snakemake execution of a bioinformatics protocol to process FASQT files

System requirements
- Linux distribution
- Your favorite code editor (visual studio code, sublime text, pycharm etc)

# How to run the pipeline:
- With this version, clone this repository in your local environment
`git clone https://github.com/GeOdette/NGS_pipeline.git`
- Next, install the neccesary bioinformatics tools required for the pipeline. Use the setup.sh file at the base of the folder.
`bash ./setup.sh`
- Alternatively, you can look at the requirements.txt file and install the tools manually
- Confirm that snakemake has been installed in your system by running `snakemake --version`. This should give you the latest version of snakemake.
- Before running this pipeline, this pipeline assumes that you have a list of links that you want to process. 
- Ensure these links are stored in a file called links.cvs
- This pipeline is developed using default settings. To enhance your run, edit the config.yaml file in the config directory to your desired needs.

## Running the pipeline
- To run the pipeline, use the following code:
`snakemake -s script.smk --cores 2`
- Set the number of cores in the `--cores 2` to your specifications

# Tools executed by the pipeline
**This pipeline execute the following tools**

- FASTQC for quality checks/screening
- FASTP for quality control with an option to run trimmomatic
- BWA for alignment/genome mapping
- SAMTOOLS for sorting and indexing
- BCFTOOLs for variant calling with an option for freebayes
- BAMTOOLS for filtering and coverage
- variant calling 

# Expected outputs
## The pipeline will generate a results folder with the following files:
- data folder with the fastq files
- fastqc_output folder containing the fastqc results. This folder also contains all_summary.txt file that contain summary statistics from all fastqc runs
- ref folder containing the reference genome
