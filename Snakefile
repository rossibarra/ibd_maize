shell.executable("zsh")

rule all:
	input:
		freebayes=expand("{project}/data/{project}.vcf.gz", project=config['PROJECT']),
		filter=expand("{project}/data/{project}.{chr}.filtered.vcf.gz", chr=range(1,config['CHROM']), project=config['PROJECT']),
		beagle=expand("{project}/data/{project}.{chr}.filtered.phased.imputed.vcf.gz", chr=range(1,config['CHROM']), project=config['PROJECT']),
		refined=expand("{project}/data/{project}.{chr}.filtered.phased.imputed.refined.ibd.gz", chr=range(1,config['CHROM']), project=config['PROJECT']),
		merge=expand("{project}/data/{project}.{chr}.filtered.phased.imputed.refined.merged", chr=range(1,config['CHROM']), project=config['PROJECT']),
		ibdne=expand("{project}/{project}.ne", project=config['PROJECT'])

include: "rules/freebayes.smk"
include: "rules/filter.smk"
include: "rules/beagle.smk"
include: "rules/refined.smk"
include: "rules/merge.smk"
include: "rules/ibdne.smk"
