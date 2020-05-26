export project=$1
sbatch beagle.sh --output /home/jri/ibd/logs/$project/beagle.%A.%a.log --array  1-11%2 -n 20 --mem  160G --partition bigmemh $project
