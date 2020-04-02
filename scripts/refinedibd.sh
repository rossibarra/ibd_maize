#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J refined
#SBATCH -o /home/jri/projects/ibd/logs/refined.out-%j.txt
#SBATCH -e /home/jri/projects/ibd/logs/refined.error-%j.txt
#SBATCH -t24:00:00
#SBATCH -n 8
#SBATCH --mem 30G 
#SBATCH --array 1-10

java -Xmx28000m  -jar /home/jri/src/ibd/refined-ibd.17Jan20.102.jar \
	gt=results/LR.allpop.phased.filtered.imputed.$SLURM_ARRAY_TASK_ID.vcf.gz \
	out=results/LR.allpop.phased.filtered.imputed.$SLURM_ARRAY_TASK_ID.refined \
	nthreads=8 \
	map=data/ogut.map  \
	length=0.5
