#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J beagle
#SBATCH -o /home/jri/projects/ibd/logs/beagle-%A_%a.out
#SBATCH -e /home/jri/projects/ibd/logs/beagle-%A_%a.error
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

set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "ERROR: \"${last_command}\" command failed with exit code $?" >&2' EXIT

java -Xmx80000m  -jar /home/jri/src/ibd/beagle.25Nov19.28d.jar \
	gt=data/JRIAL1.vcf.$SLURM_ARRAY_TASK_ID.filtered.gz \
	ne=1000000 \
	err=0.01 \
	nthreads=10 \
	map=data/ogut.map  \
	out=results/JRIAL1/JRIAL1.vcf.$SLURM_ARRAY_TASK_ID.filtered.phased.imputed
