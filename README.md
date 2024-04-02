# THE NGS PIPELINE
This pipeline is a snakemake execution of a bioinformatics protocol to process FASQT files

**System requirements**
- Linux distribution
- Your favorite code editor (Visual Studio code, sublime text, Pycharm etc)
- snakemake version 8.10.0 or later. One of the errors experienced during development 
  **'PosixPath' object has no attribute 'startswith'** is due to an incompatible version of snakemake/python.

# How to run the pipeline:
- With this version, clone this repository in your local environment

  `git clone https://github.com/GeOdette/NGS_pipeline.git`

- Next, install the necessary bioinformatics tools required for the pipeline. Use the `setup.sh` file at the base of the folder.

  `bash ./setup.sh`

- Alternatively, you can look at the requirements.txt file and install the tools manually
  
- Confirm that snakemake has been installed in your system by running `snakemake --version`. This should give you the latest version of snakemake.
  
- Before running this pipeline, this pipeline assumes that you have a list of links that you want to process.
  
- Ensure these links are stored in a file called `links.cvs`
  
- This pipeline is developed using default settings. To enhance your run, edit the `config.yaml` file in the config directory to your desired needs.

## Running the pipeline
- To run the pipeline, use the following code:
- Ensure you activate your conda environment and have snakemake version 8 and above
- Change into the project directory. Specifically, **NGS_pipeline**

  `snakemake --profile config/`

- **NOTE:** The number of cores have been set in the config file. You can adjust that depending on you compute resources

# Tools executed by the pipeline

**This pipeline execute the following tools**

- `FASTQC` for quality checks/screening
  
- `FASTP` for quality control with an option to run trimmomatic
  
- `BWA` for alignment/genome mapping
  
- `SAMTOOLS` for sorting and indexing
  
- `BCFTOOLs` for variant calling with an option for freebayes
  
- `BAMTOOLS` for filtering and coverage

# Expected outputs

## The pipeline will generate a results folder with the following files:

- `data` folder with the fastq files
  
- `fastqc_output` folder containing the fastqc results. This folder also contains all_summary.txt file that contain summary statistics from all fastqc runs
  
- `ref` folder containing the reference genome

