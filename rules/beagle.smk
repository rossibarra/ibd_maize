rule beagle:
	input: 
		vcf="{project}/data/{project}.{chr}.filtered.vcf.gz",
		map="{project}/data/{project}.map"
	output: "{project}/data/{project}.{chr}.filtered.phased.imputed.vcf.gz"
	params:
		PROJ="{project}",
		CHR="{chr}"
	shell: "java -Xmx160G -jar /home/jri/src/ibd/beagle.25Nov19.28d.jar gt={input.vcf} ne={config[NE_GUESSTIMATE]} err={config[GENOTYPE_ERROR]} nthreads=20 out={params.PROJ}/data/{params.PROJ}.{params.CHR}.filtered.phased.imputed map={input.map}"
