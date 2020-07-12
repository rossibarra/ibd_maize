#!/bin/bash

SAMPLE=$1

snakemake --rerun-incomplete \
--configfile "$SAMPLE.config.yaml" \
--cluster-config "submit.yaml" \
--jobs 100 \
--latency-wait 60 \
--cluster "sbatch -J {cluster.job-name} --mem-per-cpu {cluster.mem-per-cpu} --time {cluster.time} -p {cluster.p} -c {cluster.cpus-per-task} -o slurmout/$SAMPLE.{cluster.o}"
