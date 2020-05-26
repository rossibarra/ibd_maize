#!/bin/bash -l
#SBATCH --job-name=freebayes 
#SBATCH  -D /home/jri/projects/ibd/
#SBATCH -n 32
#SBATCH --time=14-12
#SBATCH -o /home/jri/projects/ibd/logs/fb.out-%j.txt
#SBATCH -e /home/jri/projects/ibd/logs/fb.error-%j.txt
#SBATCH --mem-per-cpu 4G  
#SBATCH --partition=high2

set -e

project=$1

date > logs/$project/freebayes.log
echo $SLURM_JOB_ID >> logs/$project/freebayes.log
cat scripts/freebayes.sh >>  logs/$project/freebayes.log

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "ERROR: \"${last_command}\" command failed with exit code $?" >&2' ERR

begin=`date +%s`

BAMLIST=data/$project/bamlist
REGION=2000000
REF=data/ref/PGA2_1_all.fa
#Zea_mays.B73_RefGen_v4.dna.toplevel.fa
FB=/home/jri/src/freebayes/scripts

$FB/freebayes-parallel <( $FB/fasta_generate_regions.py $REF.fai $REGION ) 32 -f $REF -L $BAMLIST -T 0.003 -0 > $project.vcf

end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed
