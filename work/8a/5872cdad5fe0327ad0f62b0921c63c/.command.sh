#!/bin/bash -ue
docker run -i -v /home/jgarrayo/nextflow_tutorial/nf_pipeline_trials:/home/jgarrayo/nextflow_tutorial/nf_pipeline_trials -v "$PWD":"$PWD" -w "$PWD" --name $NXF_BOXID insilicodb/kallisto:trial quant --index=index.idx --output=./out reads_1.fastq.gz reads_2.fastq.gz
