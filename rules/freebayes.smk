## FREEBAYES
#PARAMS
#REGION = "2000000"

#rule freebayes:
       input:
               bam="{project}/data/bamlist",
               ref="{project}/data/Zea_mays.B73_RefGen_v4.dna.toplevel.fa"
	params:
		PROJ="{project}"
        output:
                "{project}/data/{project}.vcf.gz"
        shell:
                "/home/jri/src/freebayes/scripts/freebayes-parallel <(/home/jri/src/freebayes/scripts/fasta_generate_regions.py {input.ref}.fai {REGION} ) 64 -f {input.ref} -L {input.bam} -T {config[THETA]} -0 -F {config[FRAC]} --min-coverage {config[MINCOV]} --limit-coverage {config[MAXCOV]} > {params.PROJ}/{params.PROJ}.vcf && bgzip {params.PROJ}/{params.PROJ}.vcf && tabix -p vcf {params.PROJ}/{params.PROJ}.vcf.gz"
