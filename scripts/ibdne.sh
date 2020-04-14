#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J ne
#SBATCH -o /home/jri/projects/ibd/logs/ne.out-%j.txt
#SBATCH -e /home/jri/projects/ibd/logs/ne.error-%j.txt
#SBATCH -t24:00:00
#SBATCH -n 30
#SBATCH --mem 30G 
#SBATCH -p high2

set -e

# run ibdne
date > logs/ne.log
echo $SLURM_JOB_ID >> logs/ne.log
cat scripts/ibdne.sh >>  logs/ne.log

plot=results/JRIAL1/neplot.pdf
if test -f "$plot"; then
    	mv -f $plot $plot.old
fi

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "ERROR: \"${last_command}\" command failed with exit code $?" >&2' ERR

cat results/JRIAL1/*merge | java -jar ~/src/ibd/ibdne.19Sep19.268.jar \
	map=data/ogut.map \
	out=results/JRIAL1/JRIAL1_ne \
	nthreads=30 \
	mincm=0.4 \
	nboots=100 \
	filtersamples=true \
	trimcm=0.1

Rscript scripts/makeplot.r

