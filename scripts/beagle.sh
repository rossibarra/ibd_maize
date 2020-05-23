#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J beagle
#SBATCH -o /home/jri/projects/ibd/logs/beagle-%A_%a.out
#SBATCH -e /home/jri/projects/ibd/logs/beagle-%A_%a.error
#SBATCH -t24:00:00
#SBATCH -n 40
#SBATCH --mem 320G 
#SBATCH -p bigmemh
#SBATCH --array 1-10

set -e
project=$1

if [  $SLURM_ARRAY_TASK_ID -eq 1 ]
then
	date > logs/$project/beagle.log
        echo $SLURM_JOB_ID >> logs/$project/beagle.log
	cat  scripts/beagle.sh >> logs/$project/beagle.log
fi


# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "ERROR: \"${last_command}\" command failed with exit code $?" >&2' ERR


if [[ $project = "JRIAL1" ]]; then
	data=data/$project/$project.vcf.$SLURM_ARRAY_TASK_ID.filtered.gz
fi

if [[ $project = "282" ]]; then
	data=data/$project/$project.vcf.$SLURM_ARRAY_TASK_ID.filtered_nohet.refiltered.gz
fi

java -Xmx310G -jar /home/jri/src/ibd/beagle.25Nov19.28d.jar \
	gt=$data \
	ne=100000 \
	err=0.025 \
	nthreads=36 \
	map=data/ogut.map  \
	out=results/$project/$project.vcf.$SLURM_ARRAY_TASK_ID.filtered.phased.imputed

