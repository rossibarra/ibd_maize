#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J filter
#SBATCH -o /home/jri/projects/ibd/logs/filter-%A_%a.out
#SBATCH -e /home/jri/projects/ibd/logs/filter-%A_%a.error
#SBATCH -t 24:00:00
#SBATCH -n 3
#SBATCH --mem 24G 
#SBATCH -p bigmemh
#SBATCH --array  1-10

set -e

project=JRIAL1

# error tracking
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "ERROR: \"${last_command}\" command failed with exit code $?" >&2' EXIT

#project specific log of script
if [  $SLURM_ARRAY_TASK_ID -eq 1 ]
then
	date > logs/$project/filter.log
	cat  scripts/filter.sh >> logs/$project/filter.log
fi

#data file
VCF=data/$project/$project.vcf

#project specific parameters
declare -A options
	options[282]="--minDP 5 --maxDP 50 --maf 0.02"
 	options[JRIAL1]="--minDP 15 --maxDP 100 --hwe 0.001 --maf 0.05"
echo ${options[282]}

#run vcftools
vcftools --gzvcf $VCF.gz --chr $SLURM_ARRAY_TASK_ID --max-alleles 2 --min-alleles 2  \
	--remove-indels --minQ 30 --minGQ 30 \
	${options[$project]} \
	--recode --stdout |  bgzip >  $VCF.$SLURM_ARRAY_TASK_ID.filtered.gz   

#index filtered file
tabix -p vcf $VCF.$SLURM_ARRAY_TASK_ID.filtered.gz  # index compressed vcf




