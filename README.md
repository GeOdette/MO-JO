# micromake
<div style="display: flex; align-items: center;">
    <img src="https://github.com/GeOdette/assets/blob/30e5952b87559dbac6625cfe6bcc0a37d7ee8a53/logo.jpg" width="400" style="margin-bottom: -30px;">
    <img src="https://github.com/GeOdette/assets/blob/30e5952b87559dbac6625cfe6bcc0a37d7ee8a53/workflow.png" width="600" style="margin-top: -30px;">
</div>


## Background
**micromake** is a pipeline built with Snakemake to provide a flexible and comprehensive analysis of microbiological sequencing data. The pipeline streamlines the entire bioinformatics workflow, from initial quality control and read cleaning, to genome alignment and variant identification. By automating these critical data processing steps, the pipeline empowers researchers to quickly move on to the more exciting phases of analysis and insights generation. The pipeline leverages a variety of well-established bioinformatics tools to ensure thorough, high-quality results, delivering a robust and efficient platform to support microbiological research.


## System requirements
- Linux distribution
- Your favorite code editor (Visual Studio code, sublime text, Pycharm, etc)
- snakemake version 8.10.0 or later. One of the errors experienced during development 
  **'PosixPath' object has no attribute 'startswith'** due to an incompatible version of snakemake/python.
## File names and naming
- The desired file naming is _R1, _R2 for this pipeline. If your file naming does not conform to this, 
  the pipeline will rename the files to match this requirement.
## Reference genome
- For a better run, choose to work with a reference genome that requires to be downloaded. Make sure to include the link to the reference genome in the `links.txt` file
- If you have a reference genome, store it in the ref genome folder. Ensure that you only have one ref genome for each run, 
  otherwise, the downstream analyses will fail.

## Test data
- There is test data, which are file links to test this pipeline in the `links.txt` file. You can remove these links to work with your own file links
## How to run the pipeline:
- With this version, clone this repository in your local environment

  `https://github.com/GeOdette/micromake.git`

- Next, install the necessary bioinformatics tools required for the pipeline. Use the `setup.sh` file at the base of the folder.

  `./setup.sh`

- Alternatively, you can look at the requirements.txt file and install the tools manually
  
- Confirm that snakemake has been installed in your system by running `snakemake --version`. This should give you the latest version of snakemake.
  
- Before running this pipeline, this pipeline assumes that you have a list of links that you want to process.
  
- Ensure these links are stored in a file called `links.txt`
  
- This pipeline is developed using default settings. To enhance your run, edit the `config.yaml` file in the config directory to your desired needs.

## Running the pipeline
- To run the pipeline, use the following code:
- Ensure you activate your conda environment and have snakemake version 8 and above
- Change into the project directory. Specifically, **micromake**

  `snakemake --profile config/`

- **NOTE:** The number of cores has been set in the config file. You can adjust that depending on your compute resources

## Tools executed by the pipeline

**This pipeline executes the following tools**

- `FASTQC` for quality checks/screening
  
- `FASTP` for quality control with an option to run trimmomatic
  
- `BWA` for alignment/genome mapping
  
- `SAMTOOLS` for sorting and indexing
  
- `BCFTOOLs` for variant calling with an option for freebayes
  
- `MULTIQC` for generating quality reports

## Expected outputs

### The pipeline will generate a results folder with the following files:

- `results/data` folder with the fastq files
  
- `results/fastqc_output` folder containing the fastqc results. This folder also contains all_summary.txt file that contains summary statistics from all fastqc runs
- `results/ref` folder containing the reference genome
- `results/bam` folder containing bam files and a `.txt` file with the summary statistics of the alignment
- `results/trimmed` containing trimmed files
- `results/trimmed/fastqc_out` containing fastqc output of the trimmed files.
- `results/variants/bcf` containing files of filtered and unfiltered/raw vcfs called from bcftools. The folder also has a `.txt` file containing summary statistics of
  the variant call
- `results/multiqc` containing multiqc report

## Running into errors:
- If you run into an error due to the bioinformatics tools used, consider restarting the pipeline again.
- The pipeline will pick from processes you have not run. 
- **Errors can occur not due to the pipeline but sequence files used** In these instances, be sure to correct the files and start the run.
- For a smooth run, use the command snakemake `--profile config/ --rerun-incomplete`

## The config file
- You may edit the config file to include as many parameters as you want.

