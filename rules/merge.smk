rule merge:
	input: 
		vcf="{project}/data/{project}.{chr}.filtered.phased.imputed.vcf.gz",
		map="{project}/data/{project}.map",
		ibd="{project}/data/{project}.{chr}.filtered.phased.imputed.refined.ibd.gz"
	params:
		gap="0.5",
		discord="2",
		CHR="{chr}",
		PROJ="{project}"
	output: "{project}/data/{project}.{chr}.filtered.phased.imputed.refined.merged"
	shell: "zcat {input.ibd} | java -Xmx8G -Xss5m -jar /home/jri/src/ibd/merge-ibd-segments.17Jan20.102.jar {input.vcf} {input.map} {params.gap} {params.discord} > {params.PROJ}/data/{params.PROJ}.{params.CHR}.filtered.phased.imputed.refined.merged"
