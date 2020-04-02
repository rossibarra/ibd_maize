
rule AddOrReplaceReadGroups:
    input:
        bam_paired = temp(config.mapped_loc + "{id}_init.bam")
    output:
        paired_RG = temp(config.mapped_loc + "{id}_paired_RG.bam")
    run:
        shell("java -Xmx4g -jar src/picard-tools-1.106/AddOrReplaceReadGroups.jar \
        INPUT={input.bam_paired} \
        OUTPUT={output.paired_RG} \
        SORT_ORDER=coordinate \
        RGID=paired \
        RGLB=paired \
        RGPL=illumina \
        RGPU=parviglumis \
        RGSM=parviglumis \
        VALIDATION_STRINGENCY=LENIENT")

rule MarkDuplicates:
    input:
        config.mapped_loc + "{id}_paired_RG.bam"
    output:
        bam = temp(config.mapped_loc + "{id}_MD.bam"),
        bai = temp(config.mapped_loc + "{id}_MD.bai"),
        metric = config.mapped_loc + "{id}_MD.txt"
    params:
        tmp = "/scratch/stittes/mark_dups/{id}"
    run:
        shell("java -Xmx4g -jar src/picard-tools-1.106/MarkDuplicates.jar \
        INPUT={input} \
        OUTPUT={output.bam} \
        METRICS_FILE={output.metric} \
        ASSUME_SORTED=true \
        REMOVE_Duplicates=true \
        VALIDATION_STRINGENCY=LENIENT \
        CREATE_INDEX=TRUE \
        SORTING_COLLECTION_SIZE_RATIO=0.15 \
        TMP_DIR={params.tmp}")


rule RealignerTargetCreator:
    input:
        ref = config.ref,
        ref_dict = config.ref_dict,
        bam = config.mapped_loc + "{id}_MD.bam",
        bai = config.mapped_loc + "{id}_MD.bai"
    output:
        temp(config.mapped_loc + "{id}_forIndelRealigner.intervals")
    run:
        shell("java -Xmx4g -jar src/GenomeAnalysisTK.jar \
        -allowPotentiallyMisencodedQuals -I {input.bam} -R {input.ref} \
        -T RealignerTargetCreator \
        -o {output}")

rule IndelRealigner:
    input:
        ref = config.ref,
        ref_dict = config.ref_dict,
        interval = config.mapped_loc + "{id}_forIndelRealigner.intervals",
        bam = config.mapped_loc + "{id}_MD.bam",
        bai = config.mapped_loc + "{id}_MD.bai"
    output:
        bam = config.mapped_loc + "{id}_dedup_realigned.bam"
    run:
        shell("java -Xmx4g -jar src/GenomeAnalysisTK.jar \
        -allowPotentiallyMisencodedQuals \
        -I {input.bam} \
        -R {input.ref} \
        -T IndelRealigner \
        -targetIntervals {input.interval} \
        -o {output.bam}")

