
rule filter:
	input: 
		"{project}/data/{project}.vcf.gz"
	output: 
		"{project}/data/{project}.{chr}.filtered.vcf.gz"
	params:
		CHR="{chr}"
	shell: 
		"module load bio3; vcftools --gzvcf {input} {config[FILTER_PARAMS]} --chr {params.CHR} --recode --stdout  | bgzip > {output[0]}"

