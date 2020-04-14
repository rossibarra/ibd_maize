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

plot=results/JRIAL1/neplot.pdf
if test -f "$plot"; then
    	mv -f $plot $plot.old
fi

cat results/JRIAL1/*merge | java -jar ~/src/ibd/ibdne.19Sep19.268.jar \
	map=data/ogut.map \
	out=results/JRIAL1/JRIAL1_ne \
	nthreads=30 \
	mincm=1 \
	nboots=100 \
	filtersamples=true \
	trimcm=0.05

if [ $? -eq 0 ]
then
	Rscript scripts/makeplot.r
else
  	echo "ERROR DUMBASS" >&2
fi





