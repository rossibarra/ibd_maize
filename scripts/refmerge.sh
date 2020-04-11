#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J refmerge
#SBATCH -o /home/jri/projects/ibd/logs/refmerge.out-%j.txt
#SBATCH -e /home/jri/projects/ibd/logs/refmerge.error-%j.txt
#SBATCH -t24:00:00
#SBATCH -n 20
#SBATCH --mem 30G 
#SBATCH --array 1-10
#SBATCH -p  high2

java -Xmx28000m  -jar /home/jri/src/ibd/refined-ibd.17Jan20.102.jar \
	gt=results/JRIAL1/JRIAL1.filtered.$SLURM_ARRAY_TASK_ID.phased.imputed.vcf.gz \
	out=results/JRIAL1/JRIAL1.filtered.phased.imputed.$SLURM_ARRAY_TASK_ID.refined \
	nthreads=16 \
	map=data/ogut.map  \
	length=0.25 \
	trim=0

in=results/JRIAL1/JRIAL1.filtered.phased.imputed.$SLURM_ARRAY_TASK_ID.refined.ibd.gz
mout=$in.merge 
vcf=results/JRIAL1/JRIAL1.filtered.$SLURM_ARRAY_TASK_ID.phased.imputed.vcf.gz 
gap=0.1 
discord=1 
map=data/ogut.map  

zcat  $in  | java -Xmx8000m  -jar /home/jri/src/ibd/merge-ibd-segments.17Jan20.102.jar \
	$vcf $map $gap $discord  > $mout
