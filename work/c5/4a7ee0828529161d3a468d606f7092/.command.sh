#!/bin/bash -ue
docker run -i -v /home/jgarrayo/nextflow_tutorial/nf_pipeline_trials:/home/jgarrayo/nextflow_tutorial/nf_pipeline_trials -v "$PWD":"$PWD" -w "$PWD" --name $NXF_BOXID insilicodb/kallisto:trial index -i index.idx transcripts.fasta.gz
