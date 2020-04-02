#!/bin/bash -l
#SBATCH --job-name=freebayes 
#SBATCH  -D /home/jri/projects/ibd/
#SBATCH -n 32
#SBATCH --time=14-12
#SBATCH -o /home/jri/projects/ibd/logs/fb.out-%j.txt
#SBATCH -e /home/jri/projects/ibd/logs/fb.error-%j.txt
#SBATCH --mem-per-cpu 4G  
#SBATCH --partition=high2


begin=`date +%s`

BAMLIST=data/bam_JRIAL1_AGPv4MtPt/bamlist
REGION=10000000
REF=data/ref/Zea_mays.B73_RefGen_v4.dna.toplevel.fa
FB=/home/jri/src/freebayes/scripts

$FB/freebayes-parallel <( $FB/fasta_generate_regions.py $REF.fai $REGION ) 32 -f $REF -L $BAMLIST -T 0.01 -0 > JRIAL1.vcf

end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed
