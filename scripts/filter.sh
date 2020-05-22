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

#filter hets from inbreds
if [[ $project = "282" || $project = "bean" ]]; then         
	~/src/vcflib/bin/vcffilter -g "! ( GT = 0/1 )" $VCF | gzip > $VCF.$SLURM_ARRAY_TASK_ID.nohet.gz
	mVCF=$VCF.$SLURM_ARRAY_TASK_ID.nohet
fi

#don't do it for outbred
if [[ $project = "JRIAL1" ]]; then
	mVCF=$VCF
fi

#project specific parameters
declare -A options
	options[282]="--maxDP 20 --maf 0.05 --minDP 3 --minQ 30 --minGQ 30 --max-missing 0.2"
 	options[JRIAL1]="--minDP 15 --maxDP 100 --hwe 0.01 --maf 0.05 --minGQ 30 --minQ 30 --max-missing 0.05"
	option[bean]="--minDP 5 --maxDP 30 --max-missing 0.2 --minQ 30 --minGQ 30 --maf 0.1"

#run vcftools
vcftools --gzvcf $mVCF.gz --chr $SLURM_ARRAY_TASK_ID --max-alleles 2 --min-alleles 2  \
	--remove-indels \
	${options[$project]} \
	--recode --stdout | awk '{gsub(/\t\.:\.:\./,"\t./.:."); print}' |  bgzip >  $VCF.$SLURM_ARRAY_TASK_ID.filtered.gz   

#index filtered file
tabix -p vcf $VCF.$SLURM_ARRAY_TASK_ID.filtered.gz  # index compressed vcf

#move logfiles
mv logs/filter-"$SLURM_ARRAY_JOB_ID"_"$SLURM_ARRAY_TASK_ID".* logs/$project/
