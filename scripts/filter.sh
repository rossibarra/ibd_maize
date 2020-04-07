#!/bin/bash -l
#SBATCH -D /home/jri/projects/ibd
#SBATCH -J filter
#SBATCH -o /home/jri/projects/ibd/logs/out-%j.txt
#SBATCH -e /home/jri/projects/ibd/logs/error-%j.txt
#SBATCH -t 24:00:00
#SBATCH -n 8
#SBATCH --mem 64G 
#SBATCH -p bigmemh

VCF=data/JRIAL1.vcf

vcftools --gzvcf $VCF.gz --max-alleles 2 --min-alleles 2  --remove-indels --minQ 30  --minQ 30 --minDP 15 --maxDP 100 --minGQ 30 --max-missing 0.1 --recode --stdout > $VCF.filtered

bgzip -c $VCF.filtered > $VCF.filtered.gz  #compress vcf
tabix -p vcf $VCF.filtered.gz  # index compressed vcf
tabix --list-chroms $VCF.filtered.gz > $VCF.chromosomes.txt  # save all the chromosome names into a file

while IFS= read -r line; do
  tabix $VCF.filtered.gz $line > $VCF.filtered.$line.vcf;
done < $VCF.chromosomes.txt  # make an individual vcf for each chromosome
