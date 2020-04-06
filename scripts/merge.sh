#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J merge
#SBATCH -o /home/jri/projects/ibd/logs/merge.out-%j.txt
#SBATCH -e /home/jri/projects/ibd/logs/merge.error-%j.txt
#SBATCH -t24:00:00
#SBATCH -n 1
#SBATCH --mem 1G 
#SBATCH --array 1-10

in=results/LJRIAL1.vcf.gz.ibdseq.out.ibd
#R.allpop.phased.filtered.imputed.$SLURM_ARRAY_TASK_ID.refined.ibd.gz 
out=results/LR.allpop.phased.filtered.imputed.$SLURM_ARRAY_TASK_ID.merge 
vcf=results/LR.allpop.phased.filtered.imputed.$SLURM_ARRAY_TASK_ID.vcf.gz 
gap=0.6 
discord=1 
map=data/ogut.map  

zcat  $in  | java -Xmx8000m  -jar /home/jri/src/ibd/merge-ibd-segments.17Jan20.102.jar $vcf   $map $gap $discord  > $out
