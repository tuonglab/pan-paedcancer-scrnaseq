#!/bin/bash

# Directory containing the files
input_dir="/scratch/user/s4543064/xiaohan-john-project/data/GSE152048"

# The original structure of the dataset is like:
# GSE152048/GSE152048_BC2.matrix/BC2/files
# For clarity, we want it to be like:
# GSE152048/GSE152048_BC2/files

# Step 1: get rid of the .matrix suffix for each sample directory
for sample_dir in ${input_dir}/*; do
    mv "$sample_dir" "${sample_dir%.matrix}"
done

# Step 2: move files to sample directories
for sample_dir in ${input_dir}/*; do
    for inner_dir in ${sample_dir}/*; do
        mv ${inner_dir}/* $sample_dir
        rm -r $inner_dir
    done
done

# Step 3: rename features.tsv to genes.tsv
for sample_dir in "${input_dir}"/*; do
    mv "${sample_dir}/features.tsv" "${sample_dir}/genes.tsv"	

    # delete useless files
    rm ${sample_dir}/*.gz
    rm ${sample_dir}/._*
done
