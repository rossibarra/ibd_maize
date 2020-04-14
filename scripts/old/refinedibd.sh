#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J refined
#SBATCH -o /home/jri/projects/ibd/logs/refined.out-%j.txt
#SBATCH -e /home/jri/projects/ibd/logs/refined.error-%j.txt
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
	length=0.5 \
	trim=0.5
