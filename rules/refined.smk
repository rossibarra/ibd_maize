rule refined:
	input: 
		vcf="{project}/data/{project}.{chr}.filtered.phased.imputed.vcf.gz",
		map="{project}/data/{project}.map"
	params:
		length="0.05",
		trim="0.005",
		lod="3",
		CHR="{chr}",
		PROJ="{project}"
	output: "{project}/data/{project}.{chr}.filtered.phased.imputed.refined.ibd.gz"
	shell: "java -Xmx30G -Xss5m -jar /home/jri/src/ibd/refined-ibd.17Jan20.102.jar gt={input.vcf} nthreads=18 out={params.PROJ}/data/{params.PROJ}.{params.CHR}.filtered.phased.imputed.refined map={input.map} length={params.length} lod={params.lod} trim={params.trim}"
