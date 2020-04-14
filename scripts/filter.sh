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

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "ERROR: \"${last_command}\" command failed with exit code $?" >&2' EXIT


if [  $SLURM_ARRAY_TASK_ID -eq 1 ]
then
	date > logs/filter.log
	cat  scripts/filter.sh >> logs/filter.log
fi

VCF=data/JRIAL1.vcf

vcftools --gzvcf $VCF.gz --chr $SLURM_ARRAY_TASK_ID --max-alleles 2 --min-alleles 2  \
	--remove-indels --minQ 30 --minDP 15 --maxDP 100 \
	--minGQ 30 --max-missing 0.05 --hwe 0.001 --maf 0.05 \
	--recode --stdout |  bgzip >  $VCF.$SLURM_ARRAY_TASK_ID.filtered.gz   

tabix -p vcf $VCF.$SLURM_ARRAY_TASK_ID.filtered.gz  # index compressed vcf

