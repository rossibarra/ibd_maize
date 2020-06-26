## General Pipeline

General  pipeline follows from [Browning et al. 2018](https://doi.org/10.1371/journal.pgen.1007385)

* align reads with [bwa-mem2](https://github.com/bwa-mem2/bwa-mem2)  (to do)
* call SNPs w/ [freebayes](https://github.com/ekg/freebayes) 
* filter  with [vcftools](https://vcftools.github.io/index.html)
* phase/impute with [Beagle5](https://faculty.washington.edu/browning/beagle/beagle.html)
* identify  IBD with [refinedIBD](http://faculty.washington.edu/browning/refined-ibd.html)
* merge IBD segments with [mergeIBD](http://faculty.washington.edu/browning/refined-ibd.html#gaps)
* estimate  Ne over time with [IBDNe](https://faculty.washington.edu/browning/ibdne.html)
* plot results  (to do)

##  General concerns

Requires estimation of small IBD regions. This means careful genotype filtering is critical, but also requires high enough SNP density to pick up small regions. And means you need a high resolution genetic map.

## Notes on implementation

* Currently memory and CPU are hard-coded into shell commands within each rule, and are also specified in the file `submit.yaml`. Make sure these match. 
* Need to run more bootstrap replicates for any final analysis of IBDNe.


