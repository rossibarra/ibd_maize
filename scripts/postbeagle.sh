#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J postfilter
#SBATCH -o /home/jri/projects/ibd/logs/filter-%A_%a.out
#SBATCH -t 24:00:00
#SBATCH -n 10
#SBATCH --mem 24G 
#SBATCH -p med2
#SBATCH --array  1-11

set -e

project=$1
module load bcftools

# error tracking
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "ERROR: \"${last_command}\" command failed with exit code $?" >&2' EXIT

#project specific log of script
if [  $SLURM_ARRAY_TASK_ID -eq 1 ]
then
	date > logs/$project/postfilter.log
        echo $SLURM_JOB_ID >> logs/$project/postfilter.log
	cat  scripts/postbeagle.sh >> logs/$project/postfilter.log
fi

#data file
VCF=results/$project/$project.vcf.$SLURM_ARRAY_TASK_ID.filtered.phased.imputed.vcf

##make hybrids
~/src/tassel-5-standalone/run_pipeline.pl -Xmx10G \
	-vcf $VCF.gz \
	-CreateHybridGenotypesPlugin \
	-hybridFile data/$project/hybrids.txt -endPlugin \
	-export $VCF.hybrid -exportType VCF

sed -e 's/0\/1/0\|1/g;s/1\/1/1\|1/g;s/0\/0/0\|0/g;s/1\/0/1\|0/g;' $VCF.hybrid.vcf | grep -v "\./\." > $VCF.hybrid.rephased.vcf

#filter hets from inbreds
bcftools view -e 'COUNT(GT="AA")=N_SAMPLES || COUNT(GT="RR")=N_SAMPLES' $VCF.hybrid.rephased.vcf -o $VCF.hybrid.poly.gz -O z
tabix -p vcf $VCF.hybrid.poly.gz

