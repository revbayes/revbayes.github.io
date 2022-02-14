#!/bin/bash

NUM_CORES=2
NUM_REPS=2
NUM_MCMC_ITER=200

OUTPUT_DIR="output"
DATA_DIR="data"
LOG_DIR="logs"

if [ ${LOG_DIR} != "" ]; then
  if [ ! -d ${LOG_DIR} ]; then
    mkdir ${LOG_DIR}
  fi
fi


for f in ${DATA_DIR}/*.fas;
do

    ds=$(basename -- "$f")
    extension="${ds##*.}"
    ds="${ds%.*}"

    echo "GENE=\"${ds}\"; source(\"scripts/mcmc_unrooted_gene_tree.Rev\")" | rb > ${LOG_DIR}/run_${ds}.out

done
