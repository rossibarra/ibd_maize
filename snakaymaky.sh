#!/bin/bash

TAXA=$1

snakemake --rerun-incomplete \
--configfile "$TAXA/config.yaml" \
--cluster-config "submit.yaml" \
--jobs 100 \
--cluster "sbatch --mem {cluster.mem} -J {cluster.job-name} --time {cluster.time} -p {cluster.p} -c {cluster.cpus-per-task} -o slurmout/$TAXA.{cluster.o}"
