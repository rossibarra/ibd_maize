#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J ne
#SBATCH -o /home/jri/projects/ibd/logs/ne.out-%j.txt
#SBATCH -e /home/jri/projects/ibd/logs/ne.error-%j.txt
#SBATCH -t24:00:00
#SBATCH -n 20
#SBATCH --mem 30G 

# run ibdne
cat  results/JRIAL1.vcf.filtered.gz.ibdseq.out.ibd | java -jar ~/src/ibd/ibdne.19Sep19.268.jar \
	map=data/ogut.map \
	out=results/JRIAL1_ne \
	nthreads=20 \
	mincm=0.2 \
	nboots=0 \
	filtersamples=false \
	trimcm=0 \
#	minregion=5
