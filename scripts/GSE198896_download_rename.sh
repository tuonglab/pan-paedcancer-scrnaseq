#!/bin/bash

accession_code="GSE198896"
data_dir="/scratch/user/s4543064/xiaohan-john-project/data"
write_dir="/scratch/user/s4543064/xiaohan-john-project/write"

dataset_dir="$data_dir/$accession_code" # where the dataset is downloaded to
output_dir="$write_dir/$accession_code" # where the AnnData objects are stored

mkdir $dataset_dir
mkdir $output_dir

# Download the dataset from GEO
wget -e robots=off -nH -nd \
    "ftp://ftp.ncbi.nlm.nih.gov/geo/series/${accession_code:0:${#accession_code}-3}nnn/${accession_code}/suppl/${accession_code}_RAW.tar" \
    -P "$data_dir"

# Extract the files from the tar to dataset directory
tar -xvf  "$data_dir/${accession_code}_RAW.tar" -C $dataset_dir
rm "$data_dir/${accession_code}_RAW.tar"

# This dataset includes .tar.gz file for each sample
# Within each sample .tar.gz file, there is a directory containing barcodes/features/matrix files

# Iterate through each .tar.gz file
for file in ${dataset_dir}/*.tar.gz; do
    # Extract the sample name from the file name
    sample_name=$(basename "$file" .tar.gz)
    
    # Create a directory for the sample if it doesn't exist
    mkdir -p ${dataset_dir}/"$sample_name"
    
    # Extract files from the .tar.gz file into the sample directory
    tar -xvf "$file" -C ${dataset_dir}/"$sample_name" --strip-components=1

    rm $file
done

# gzip all the barcodes/features/matrix files
for sample_dir in "${dataset_dir}"/*; do
    for file in "${sample_dir}"/*; do
        gzip $file
    done	
done