#!/bin/bash

# TAXA=$1

snakemake --rerun-incomplete \
-R ibdne \
-R refined \
-R merge \
--configfile "config.yaml" \
--cluster-config "submit.yaml" \
--latency-wait 60 \
--jobs 500 \
--cluster "sbatch --mem {cluster.mem} -J {cluster.job-name} --time {cluster.time} -p {cluster.p} -c {cluster.cpus-per-task} -o slurmout/bigsnake.{cluster.o}" 
