#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J refmerge
#SBATCH -o /home/jri/projects/ibd/logs/refmerge-%A_%a.out
#SBATCH -e /home/jri/projects/ibd/logs/refmerge-%A_%a.error
#SBATCH -t24:00:00
#SBATCH -n 20
#SBATCH --mem 30G 
#SBATCH -p  high2
#SBATCH --array 1-10 

set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "ERROR: \"${last_command}\" command failed with exit code $?" >&2' ERR

in=results/JRIAL1/JRIAL1.vcf.$SLURM_ARRAY_TASK_ID.filtered.phased.imputed

java -Xmx28000m  -jar /home/jri/src/ibd/refined-ibd.17Jan20.102.jar \
	gt=$in.vcf.gz \
	out=$in.refined \
	nthreads=16 \
	map=data/ogut.map  \
	length=0.3 \
	trim=.1

in_ibd=$in.refined.ibd.gz
mout=$in.merge 
vcf=$in.vcf.gz 
gap=0.3 
discord=1 
map=data/ogut.map  

zcat  $in_ibd | java -Xmx8000m  -jar /home/jri/src/ibd/merge-ibd-segments.17Jan20.102.jar \
	$vcf $map $gap $discord  > $mout
