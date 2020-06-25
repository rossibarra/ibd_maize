## General Pipeline

General  pipeline follows from [Browning et al. 2018](https://doi.org/10.1371/journal.pgen.1007385)

* align reads with [bwa-mem2](https://github.com/bwa-mem2/bwa-mem2)  (to do)
* call SNPs w/ [freebayes](https://github.com/ekg/freebayes) 
* filter  with [vcftools](https://vcftools.github.io/index.html)
* phase/impute with [Beagle5](https://faculty.washington.edu/browning/beagle/beagle.html)
* identify  IBD with [refinedIBD](http://faculty.washington.edu/browning/refined-ibd.html)
* merge IBD segments with [mergeIBD](http://faculty.washington.edu/browning/refined-ibd.html#gaps)
* estimate  Ne over time with [IBDNe](https://faculty.washington.edu/browning/ibdne.html)
