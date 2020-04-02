#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J ne
#SBATCH -o /home/jri/projects/ibd/logs/ne.out-%j.txt
#SBATCH -e /home/jri/projects/ibd/logs/ne.error-%j.txt
#SBATCH -t24:00:00
#SBATCH -n 20
#SBATCH --mem 30G 

# run ibdne
cat  results/LR*merge | java -jar ~/src/ibd/ibdne.19Sep19.268.jar \
	map=data/ogut.map \
	out=results/ne \
	nthreads=20 \
	mincm=1  \
	nboots=10 \
	filtersamples=false \
	trimcm=0 \
	minregion=5
