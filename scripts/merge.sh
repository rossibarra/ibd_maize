#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J merge
#SBATCH -o /home/jri/projects/ibd/logs/merge.out-%j.txt
#SBATCH -e /home/jri/projects/ibd/logs/merge.error-%j.txt
#SBATCH -t24:00:00
#SBATCH -n 2
#SBATCH --mem 10G 
#SBATCH -p bigmemh

basename=JRIAL1.vcf.filtered.gz
in=results/$basename.ibdseq.out.ibd
#R.allpop.phased.filtered.imputed.$SLURM_ARRAY_TASK_ID.refined.ibd.gz 
out=results/$basename.merge 
vcf=data/$basename 
gap=0.6 
discord=1 
map=data/ogut.map  

cat  $in  | java -Xmx8000m  -jar /home/jri/src/ibd/merge-ibd-segments.17Jan20.102.jar $vcf   $map $gap $discord  > $out
