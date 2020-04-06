#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd/
#SBATCH -J ibdseq
#SBATCH -o /home/jri/projects/ibd/logs/ibdseq_out-%j.txt
#SBATCH -e /home/jri/projects/ibd/logs/ibdseq_error-%j.txt
#SBATCH -t 6-12
#SBATCH -n 12
#SBATCH --mem 96G 
#SBATCH -p bigmemh

VCF=/home/jri/projects/ibd/data/JRIAL1.vcf.filtered.gz
java -Xmx90000m -jar ~/src/ibd/ibdseq.r1206.jar gt=$VCF out=$VCF.ibdseq.out nthreads=12
