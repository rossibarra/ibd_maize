rule freebayes:
	input:
		bam="{project}/data/bamlist",
		ref="{project}/data/Zea_mays.B73_RefGen_v4.dna.toplevel.fa"
	params:
		PROJ="{project}",
		REGION="2000000"
	output:
		"{project}/data/{project}.vcf.gz"
	shell:
		"/home/jri/src/freebayes/scripts/freebayes-parallel <(/home/jri/src/freebayes/scripts/fasta_generate_regions.py {input.ref}.fai {params.REGION} ) 64 -f {input.ref} -L {input.bam} -T {config[THETA]} -0 -F {config[FRAC]} --min-coverage {config[MINCOV]} --limit-coverage {config[MAXCOV]} > {params.PROJ}/data/{params.PROJ}.vcf && bgzip {params.PROJ}/data/{params.PROJ}.vcf && tabix -p vcf {params.PROJ}/data/{params.PROJ}.vcf.gz"
