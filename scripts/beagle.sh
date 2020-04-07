#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J beagle
#SBATCH -o /home/jri/projects/ibd/logs/beagle.out-%j.txt
#SBATCH -e /home/jri/projects/ibd/logs/beagle.error-%j.txt
#SBATCH -t24:00:00
#SBATCH -n 20
#SBATCH --mem 60G 
#SBATCH --array 1-10
#SBATCH -p  high2

java -Xmx48000m  -jar /home/jri/src/ibd/beagle.25Nov19.28d.jar \
	gt=data/JRIAL1.vcf.filtered.gz \
	ne=100000 \
	chrom=$SLURM_ARRAY_TASK_ID \
	err=0.001 \
	nthreads=20 \
	map=data/ogut.map  \
	out=results/JRIAL1.filtered.phased.imputed.$SLURM_ARRAY_TASK_ID 
#	out=results/LR.allpop.phased.filtered.imputed.$SLURM_ARRAY_TASK_ID 
#gt=data/LR.allpop.phased.filtered22.$SLURM_ARRAY_TASK_ID.vcf.gz \
