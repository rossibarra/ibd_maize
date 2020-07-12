
rule refined:
	input: 
		vcf="{pop}/data/{pop}.{chr}.filtered.phased.imputed.vcf.gz",
		map="{pop}/data/{pop}.map"
	params:
		length="0.01",
		trim="0.0005",
		lod="1.5",
	output: "{pop}/data/{pop}.{chr}.filtered.phased.imputed.refined.ibd.gz"
	shell: "java -Xmx30G -Xss5m -jar /home/jri/src/ibd/refined-ibd.17Jan20.102.jar gt={input.vcf} nthreads=18 out={wildcards.pop}/data/{wildcards.pop}.{wildcards.chr}.filtered.phased.imputed.refined map={input.map} length={params.length} lod={params.lod} trim={params.trim}"
