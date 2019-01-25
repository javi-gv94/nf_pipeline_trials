#!/usr/bin/env nextflow

// default parameter values

params.fastaFile = "$baseDir/data/transcripts.fasta.gz"
params.fastqFile1 = "$baseDir/data/reads_1.fastq.gz"
params.fastqFile2 = "$baseDir/data/reads_2.fastq.gz"
params.out = "out"

log.info """\
		   P I P E L I N E    
         =============================
         genome: ${params.fastaFile}
         annot : ${params.fastqFile1}
         reads : ${params.fastqFile2}
         outdir: ${params.out}
         """
.stripIndent()

// input files

fasta = file(params.fastaFile)
fastq1 = file(params.fastqFile1)
fastq2 = file(params.fastqFile2)

// output 

result = file(params.out)

process indexation {

	container true

	input:
	file fasta

	output:
	file 'index.idx' into INDEX

	"""
	insilicodb/kallisto:trial index -i index.idx $fasta
	"""

}


process quantification {
	
	container true

	input:
	file idxFile from INDEX
	file fastq1
	file fastq2

	output:
	file "./out/abundance.h5" into QUANT

	"""
	insilicodb/kallisto:trial quant --index=$idxFile --output=./out $fastq1 $fastq2
	"""

}


process exportRObject {

	container 'insilicodb/kallisto:trial'
	publishDir params.out, mode: 'copy' 

	input:
	file quantH5 from QUANT

	output:
	file "kallisto_sleuth.RData" into OUTPUT

	script:
	"""
	#! /usr/bin/env Rscript

	library("sleuth")
	k <- read_kallisto("${quantH5}")
	save(k, file = "./kallisto_sleuth.RData")
	"""

}

process collectOutput {

	input:
	file filename from OUTPUT

	"""
	mkdir -p ${params.out}
	cp ${filename} ${params.out}${filename}
	"""
}

workflow.onComplete { 
	println ( workflow.success ? "Done!" : "Oops .. something went wrong" )
}
