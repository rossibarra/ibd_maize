#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J filter
#SBATCH -o /home/jri/projects/ibd/logs/out-%j.txt
#SBATCH -e /home/jri/projects/ibd/logs/error-%j.txt
#SBATCH -t 24:00:00
#SBATCH -n 8
#SBATCH --mem 24G 

VCF=data/JRIAL1.vcf

#vcftools --gzvcf /group/jrigrp10/al/phased_single_pop/LRs_eagle2_hapcut.merged_Chr$SLURM_ARRAY_TASK_ID.vcf.gz 	--max-alleles 2 --min-alleles 2 --phased --minQ 500 --remove-indels  --max-missing .02 --minDP 20	--maxDP 200 --recode --stdout | gzip > LR.allpop.phased.filtered22.$SLURM_ARRAY_TASK_ID.vcf.gz
vcftools --gzvcf $VCF.gz --max-alleles 2 --min-alleles 2  --remove-indels --minQ 30  --minQ 30 --minDP 15 --maxDP 100 --minGQ 30 --max-missing 0.1 --recode --stdout | gzip > $VCF.filtered.gz
