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

project=$1

# run ibdne
date > logs/ne.log
echo $SLURM_JOB_ID >> logs/$project/ne.log
cat scripts/ibdne.sh >>  logs/$project/ne.log

plot=results/$project/neplot.pdf
if test -f "$plot"; then
    	mv -f $plot $plot.old
	rm results/$project/"$project"_ne.ne
fi

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "ERROR: \"${last_command}\" command failed with exit code $?" >&2' ERR

ls -lth results/$project/*merge >> ne.log

cat results/$project/*merge | java -jar ~/src/ibd/ibdne.19Sep19.268.jar \
	map=data/ogut.map \
	out=results/$project/"$project"_ne \
	nthreads=30 \
	mincm=.05 \
	gmax=1500 \
	nboots=100 \
	nits=2000 \
	filtersamples=true \
	trimcm=0.2

Rscript scripts/makeplot.r
