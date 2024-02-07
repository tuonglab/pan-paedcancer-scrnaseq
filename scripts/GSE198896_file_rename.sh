#!/bin/bash

# Directory containing the files
input_dir="/scratch/user/s4543064/xiaohan-john-project/data/GSE198896"

# Loop through each sample directory
for sample_dir in "${input_dir}"/*; do
    # Rename feature.txt to gene.txt in each sample directory
    mv "${sample_dir}/features.tsv" "${sample_dir}/genes.tsv"	
done
