#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J merge
#SBATCH -o /home/jri/projects/ibd/logs/merge.out-%j.txt
#SBATCH -e /home/jri/projects/ibd/logs/merge.error-%j.txt
#SBATCH -t24:00:00
#SBATCH -n 2
#SBATCH --mem 10G 
#SBATCH -p high2
#SBATCH --array 1-10

in=results/JRIAL1/JRIAL1.filtered.phased.imputed.$SLURM_ARRAY_TASK_ID.refined.ibd.gz
out=$in.merge 
vcf=results/JRIAL1/JRIAL1.filtered.$SLURM_ARRAY_TASK_ID.phased.imputed.vcf.gz 
gap=0.25 
discord=1 
map=data/ogut.map  

zcat  $in  | java -Xmx8000m  -jar /home/jri/src/ibd/merge-ibd-segments.17Jan20.102.jar $vcf   $map $gap $discord  > $out
