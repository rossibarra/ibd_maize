
from glob import glob
import re

in_loc = "data/ref/"
mapped_loc = "data/mapped/"
fq_loc = "data/fastq/"
fq1_suffix = "_1.fq.gz"
fq1_suffix = "_2.fq.gz"

#ref info. assumes relevant indexing has been done before running the pipeline. 
ref = f"{in_loc}Sorghum_bicolor.Sorghum_bicolor_NCBIv3.dna.toplevel.fa"
ref_dict = f"{in_loc}Sorghum_bicolor.Sorghum_bicolor_NCBIv3.dna.toplevel.dict"

#input and output file paths#
raw_loc = "/group/jrigrp4/landrace_AGPv4/"

#input file prefixes from fastq
ids = ["id1", "id2", "id3"] #just an example -- gotta input these somehow

#OUTPUT FILES
bams = [f"{mapped_loc}{idi}_init.bam" for idi in ids]
#bams = [f"{mapped_loc}{id}_dedup_realigned.bam" for id in ids]

#other config params
mem_threads = 18
