#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J beagle
#SBATCH -o /home/jri/projects/ibd/logs/beagle.out-%j.txt
#SBATCH -e /home/jri/projects/ibd/logs/beagle.error-%j.txt
#SBATCH -t24:00:00
#SBATCH -n 12
#SBATCH --mem 160G 
#SBATCH -p bigmemh
#SBATCH --array 1-10

if [  $SLURM_ARRAY_TASK_ID -eq 1 ]
then
	date > logs/beagle.log
	cat  scripts/beagle.sh >> logs/beagle.log
fi

java -Xmx80000m  -jar /home/jri/src/ibd/beagle.25Nov19.28d.jar \
	gt=data/JRIAL1.vcf.$SLURM_ARRAY_TASK_ID.filtered.gz \
	ne=100000 \
	err=0.01 \
	nthreads=10 \
	map=data/ogut.map  \
	out=results/JRIAL1/JRIAL1.filtered.$SLURM_ARRAY_TASK_ID.phased.imputed
