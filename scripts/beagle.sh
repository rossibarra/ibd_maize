#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J beagle
#SBATCH -t24:00:00
#SBATCH -n 20
#SBATCH -p bigmemh
#SBATCH --mem 160G
#SBATCH --array  1-5,10%3
#SBATCH -o /home/jri/projects/ibd/logs/beagle-%A_%a.out 

set -e
project=$1

if [  $SLURM_ARRAY_TASK_ID -eq 1 ]
then
	date > logs/$project/beagle.log
        echo $SLURM_JOB_ID >> logs/$project/beagle.log
	cat  scripts/runbeagle.sh >> logs/$project/beagle.log
	cat  scripts/beagle.sh >> logs/$project/beagle.log
fi

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "ERROR: \"${last_command}\" command failed with exit code $?" >&2' ERR

data=data/$project/$project.vcf.$SLURM_ARRAY_TASK_ID.filtered.gz

java -Xmx150G -jar /home/jri/src/ibd/beagle.25Nov19.28d.jar \
	gt=$data \
	ne=100000 \
	err=0.025 \
	nthreads=20 \
	out=results/$project/$project.vcf.$SLURM_ARRAY_TASK_ID.filtered.phased.imputed

#	map=data/bean.map  \

