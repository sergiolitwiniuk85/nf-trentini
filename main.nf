//#! usr/bin/env nextflow
//process zero loadfiles

include { fastqc } from './proc/fastqc.nf'
include { fastp } from './proc/fastp.nf'
include { fastqc2 } from './proc/fastqc2.nf'

params.reads = './Data/*{1,2}.fastq.gz'
params.outdir = "output"


ifile = Channel.fromFilePairs(params.reads)
       .set {reads_ch}   
              
workflow{

//--------------First_step-------------------------------------

//fastqc (before-QC)

       fastqc(reads_ch)

//fastp

       fastp_ch = fastp(reads_ch)

       fastpOut = fastp.out[0].join(fastp.out[1])

//fastqc (after-QC)

       fastqc2(fastp.out.fastp_1.concat(fastp.out.fastp_2).view())

       }









