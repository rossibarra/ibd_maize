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

date > logs/JRIAL1/freebayes.log
echo $SLURM_JOB_ID >> logs/JRIAL1/freebayes.log
cat scripts/freebayes.sh >>  logs/JRIAL1/freebayes.log

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "ERROR: \"${last_command}\" command failed with exit code $?" >&2' ERR

begin=`date +%s`

BAMLIST=data/JRIAL1/bamlist
REGION=10000000
REF=data/ref/Zea_mays.B73_RefGen_v4.dna.toplevel.fa
FB=/home/jri/src/freebayes/scripts

$FB/freebayes-parallel <( $FB/fasta_generate_regions.py $REF.fai $REGION ) 32 -f $REF -L $BAMLIST -T 0.01 -0 > JRIAL1.vcf

end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed
