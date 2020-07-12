shell.executable("/bin/bash")

POPS = {
	"LGU":range(1,config['CHROM']), 
	"AMA":range(1,config['CHROM']), 
	"SLO":range(1,config['CHROM']), 
	"CEL":range(1,config['CHROM']), 
	"PAL":range(1,config['CHROM']), 
	"tLGU":range(1,config['CHROM']), 
	"tAMA":range(1,config['CHROM']), 
	"tSLO":range(1,config['CHROM']), 
	"tCEL":range(1,config['CHROM']), 
	"tPAL":range(1,config['CHROM']), 
	"tELR":range(1,config['CHROM'])
}

rule all:
	input:
		#freebayes=expand("{project}/data/{project}.vcf.gz", project=config['PROJECT']),
		#filter=expand("{project}/data/{project}.{chr}.filtered.vcf.gz", chr=range(1,config['CHROM']), project=config['PROJECT']),
		#beagle=expand("{project}/data/{project}.{chr}.filtered.phased.imputed.vcf.gz", chr=range(1,config['CHROM']), project=config['PROJECT']),
		#refined=expand("{project}/data/{project}.{chr}.filtered.phased.imputed.refined.ibd.gz", project=list(POPS.keys())),
		#merge=expand("{project}/data/{project}.{chr}.filtered.phased.imputed.refined.merged", chr=range(1,config['CHROM']), project=pop),
		expand("{project}/{project}.ne", project=list(POPS.keys()))

#include: "rules/freebayes.smk"
#include: "rules/filter.smk"
#include: "rules/beagle.smk"
include: "rules/refined.smk"
include: "rules/merge.smk"
include: "rules/ibdne.smk"
