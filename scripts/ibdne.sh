#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J ne
#SBATCH -o /home/jri/projects/ibd/logs/ne.out-%j.txt
#SBATCH -e /home/jri/projects/ibd/logs/ne.error-%j.txt
#SBATCH -t24:00:00
#SBATCH -n 30
#SBATCH --mem 30G 
#SBATCH -p high2

# run ibdne
date > logs/ne.log
cat scripts/ibdne.sh >>  logs/ne.log

cat results/JRIAL1/*merge | java -jar ~/src/ibd/ibdne.19Sep19.268.jar \
	map=data/ogut.map \
	out=results/JRIAL1/JRIAL1_ne \
	nthreads=30 \
	mincm=0.4 \
	nboots=100 \
	filtersamples=true \
	trimcm=0

Rscript scripts/makeplot.r
