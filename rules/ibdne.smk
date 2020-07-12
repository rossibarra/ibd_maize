
rule ibdne:
	input: 
	        merge=lambda wildcards: expand("{pop}/data/{pop}.{chr}.filtered.phased.imputed.refined.merged", pop=wildcards.pop, chr=POPS[wildcards.pop]),
		map="{pop}/data/{pop}.map"
	output: 
		"{pop}/{pop}.ne"
	params:
		NITS="2000",
		GMAX="1000",
		NBOOTS="20",
		MINCM="0.1",
		TRIMCM="0.2",
	shell: "cat {input.merge} | java -Xmx48G -jar /home/jri/src/ibd/ibdne.19Sep19.268.jar \
		map={input.map} \
		nits={params.NITS} \
		gmax={params.GMAX} \
		nboots={params.NBOOTS} \
		mincm={params.MINCM} \
		trimcm={params.TRIMCM} \
		nthreads=30 \
		filtersamples=TRUE \
		out={wildcards.pop}/{wildcards.pop}"
