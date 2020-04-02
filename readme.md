## call SNPs (freebayes.sh)
## filter vcf (filter.sh)

## plan A:
* phase (also beagle??) <-haven't done this step before
* impute missing data (beagle.sh)
* refinedibd on phased data (refinedibd.sh)
* merge ibd calls (merge.sh)
* ne estimates (ibdne.sh)

## plan B:
* ibd with ibdseq on unphased data  (ibdseq.sh)
* merge ibd calls (merge.sh)
* ne estimates (ibdne.sh)

### old plan
phased vcfs with eagle2 and hapcut <- didn't do 
filter with filter script
impute missing with beagle script
run refined ibd
merge ibd blocks
run ibdne
