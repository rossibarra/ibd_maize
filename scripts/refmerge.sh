#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J refmerge
#SBATCH -o /home/jri/projects/ibd/logs/refmerge-%A_%a.out
#SBATCH -e /home/jri/projects/ibd/logs/refmerge-%A_%a.error
#SBATCH -t24:00:00
#SBATCH -n 18
#SBATCH --mem 30G 
#SBATCH -p  med2
#SBATCH --array 1-10 

set -e

project=$1

if [  $SLURM_ARRAY_TASK_ID -eq 1 ]
then
	date > logs/$project/refmerge.log
        echo $SLURM_JOB_ID >> logs/$project/refmerge.log
	cat  scripts/refmerge.sh >> logs/$project/refmerge.log
fi


# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "ERROR: \"${last_command}\" command failed with exit code $?" >&2' ERR

in=results/$project/$project.vcf.$SLURM_ARRAY_TASK_ID.filtered.phased.imputed
inibd=$in.refined.ibd.gz

if test -f $inibd; then
        rm $inibd
fi

java -Xmx28000m  -jar /home/jri/src/ibd/refined-ibd.17Jan20.102.jar \
	gt=$in.vcf.gz \
	out=$in.refined \
	nthreads=18 \
	map=data/ogut.map  \
	length=0.05 \
	lod=3 \
	trim=0.001

mout=$in.merge 
vcf=$in.vcf.gz 
gap=.5 
discord=2 
map=data/ogut.map  
if test -f $mout; then
	rm $mout
fi

zcat  $inibd | java -Xmx8000m  -jar /home/jri/src/ibd/merge-ibd-segments.17Jan20.102.jar \
	$vcf $map $gap $discord  > $mout
