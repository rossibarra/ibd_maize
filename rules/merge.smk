rule merge:
	input: 
		vcf="{pop}/data/{pop}.{chr}.filtered.phased.imputed.vcf.gz",
		map="{pop}/data/{pop}.map",
		ibd="{pop}/data/{pop}.{chr}.filtered.phased.imputed.refined.ibd.gz"
	params:
		gap="0.5",
		discord="3",
	output: "{pop}/data/{pop}.{chr}.filtered.phased.imputed.refined.merged"
	shell: "zcat {input.ibd} | java -Xmx8G -Xss5m -jar /home/jri/src/ibd/merge-ibd-segments.17Jan20.102.jar {input.vcf} {input.map} {params.gap} {params.discord} > {wildcards.pop}/data/{wildcards.pop}.{wildcards.chr}.filtered.phased.imputed.refined.merged"
