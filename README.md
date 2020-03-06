# smk_stacks_workflow

[![https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg](https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg)](https://singularity-hub.org/collections/4122)

RADseq workflow built around STACKS full-parallelized and automated using SNAKEMAKE 


# Installation

## Prerequisites

* python3
* snakemake
* singularity
 
## Singularity/Docker container

Pull the container to your machine
``` 
singularity pull --name gbs_workflow.sif shub://Grelot/smk_stacks_workflow:gbs_workflow
```
Check if the container is working well
```
singularity run gbs_workflow.sif
```
should output
```
Opening container...ubuntu beaver: STACKS 2.5, Trimmomatic 0.33, bwa-mem 1, bwa-mem 2, samtools 1.10, vcftools 0.1.15, bedtools 2.26.0
```
Example of use: running `stacks2` from the container
```
singularity exec gbs_workflow.sif gstacks --version
```
should output
```
gstacks 2.5
```


## Data files

Illumina paired-end fastq files must be into a folder:

```
.
└── FastqFolder
    ├── runA_R1.fastq.gz
    ├── runA_R2.fastq.gz
    ├── runB_R1.fastq.gz
    └── runB_R2.fastq.gz

```


## Configuration

* Snakemake will use information stored into a configuration file in order to run the workflow.
* You have to modify [01_infos/config.yaml](01_infos/config.yaml) to configure your own workflow.
* A complete description of the configuration file is available on this [wiki page](https://github.com/Grelot/smk_stacks_workflow/wiki/Configuration-file).

