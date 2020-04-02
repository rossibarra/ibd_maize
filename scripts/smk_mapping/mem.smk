rule bwa_mem:
    input:
        config.ref,
        r1 = f"{config.fq_loc}{id}{config.fq1_suffix}",
        r2 = f"{config.fq_loc}{id}{config.fq2_suffix}",
    output:
        temp(config.mapped_loc + "{id}_init.bam")
    threads: config.mem_threads
    run:
        shell("bwa mem -t {threads} {config.ref} {input.r1} {input.r2} | samtools sort -o {output} -")
