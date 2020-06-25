rule ibdne:
	input: 
		merge=expand("{project}/data/{project}.{chr}.filtered.phased.imputed.refined.merged", chr=range(1,12), project=config['PROJECT']),
		map="{project}/data/{project}.map"
	params:
		NITS="2000",
		GMAX="1000",
		NBOOTS="20",
		MINCM="0.05",
		TRIMCM="0.2",
		PROJ="{project}"
	output: "{project}/{project}.ne"
	shell: "cat {input.merge} | java -Xmx48G -jar /home/jri/src/ibd/ibdne.19Sep19.268.jar \
		map={input.map} \
		nits={params.NITS} \
		gmax={params.GMAX} \
		nboots={params.NBOOTS} \
		mincm={params.MINCM} \
		trimcm={params.TRIMCM} \
		nthreads=30 \
		filtersamples=TRUE \
		out={params.PROJ}/{params.PROJ}"
