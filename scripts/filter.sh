#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J filter
#SBATCH -o /home/jri/projects/ibd/logs/filter-%A_%a.out
#SBATCH -e /home/jri/projects/ibd/logs/filter-%A_%a.error
#SBATCH -t 24:00:00
#SBATCH -n 10
#SBATCH --mem 24G 
#SBATCH -p med2
#SBATCH --array  1-10

set -e

project=$1

# error tracking
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "ERROR: \"${last_command}\" command failed with exit code $?" >&2' EXIT

#project specific log of script
if [  $SLURM_ARRAY_TASK_ID -eq 1 ]
then
	date > logs/$project/filter.log
        echo $SLURM_JOB_ID >> logs/$project/filter.log
	cat  scripts/filter.sh >> logs/$project/filter.log
fi

#data file
VCF=data/$project/$project.vcf

#project specific parameters
declare -A options
	options[282]="--maxDP 50000 --maf 0.05 --minDP 3 --max-missing 0.5"
 	options[JRIAL1]="--minDP 15 --maxDP 100 --hwe 0.01 --maf 0.05 --minGQ 30 --minQ 30 --max-missing 0.05"

#run vcftools
vcftools --gzvcf $VCF.gz --chr $SLURM_ARRAY_TASK_ID --max-alleles 2 --min-alleles 2  \
	--remove-indels \
	${options[$project]} \
	--recode --stdout |  bgzip >  $VCF.$SLURM_ARRAY_TASK_ID.filtered.gz   

#index filtered file
#tabix -p vcf $VCF.$SLURM_ARRAY_TASK_ID.filtered.gz  # index compressed vcf

if [[ $project = "282" ]]; then         
	~/src/vcflib/bin/vcffilter -g "! ( GT = 0/1 )" $VCF.$SLURM_ARRAY_TASK_ID.filtered.gz | gzip > $VCF.$SLURM_ARRAY_TASK_ID.filtered_nohet.gz
	vcftools --gzvcf $VCF.$SLURM_ARRAY_TASK_ID.filtered_nohet.gz --max-missing 0.5 --recode --stdout | bgzip >  $VCF.$SLURM_ARRAY_TASK_ID.filtered_nohet.refiltered.gz
fi

#move logfiles
mv /home/jri/projects/ibd/logs/filter-$SLURM_ARRAY_JOB_ID.$SLURM_ARRAY_TASK_ID* /home/jri/projects/ibd/logs/$project/
