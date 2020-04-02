#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd/
#SBATCH -J alignment
#SBATCH -o /home/jri/projects/ibd/logs/out.align-%j.txt
#SBATCH -e /home/jri/projects/ibd/logs/error.align-%j.txt
#SBATCH --mem 128G 
#SBATCH -t 48:40:00
#SBATCH --array 27-27
#SBATCH -n 24
#SBATCH -p bigmemh

read1=data/JRIAL1_fastq/JRIAL1-"$SLURM_ARRAY_TASK_ID"_R1.fastq.gz
read2=data/JRIAL1_fastq/JRIAL1-"$SLURM_ARRAY_TASK_ID"_R2.fastq.gz
bamname=JRIAL1."$SLURM_ARRAY_TASK_ID".sorted.B73AGPv4
ref=/group/jrigrp/Share/assemblies/Zea_mays.AGPv4.dna.chr.fa

#module load bwa-mem2/2.0pre2-intel
module load bwa-mem2/2.0pre2-gcc 
module load samtools
module load intel 

#make  sure you  run "bwa-mem2 index $ref" first
bwa-mem2 mem -t 20 $ref $read1 $read2 > $bamname.sam

#| \
#	samtools sort -O 'bam' -T "$bamname".tmp - | \
#	tee "$bamname".bam | \
#	samtools flagstat - > "$bamname".stats
