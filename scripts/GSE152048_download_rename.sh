#!/bin/bash

accession_code="GSE152048"
data_dir="/scratch/user/s4543064/xiaohan-john-project/data"
write_dir="/scratch/user/s4543064/xiaohan-john-project/write"

dataset_dir="$data_dir/$accession_code" # where the dataset is downloaded to
output_dir="$write_dir/$accession_code" # where the AnnData objects are stored

mkdir $dataset_dir
mkdir $output_dir

# List of patient IDs to download
patient_ids=("2" "3" "11" "16" "20" "22")

for patient_id in "${patient_ids[@]}"; do
    # Download the dataset from GEO
    wget -e robots=off -nH -nd \
        "ftp://ftp.ncbi.nlm.nih.gov/geo/series/${accession_code:0:${#accession_code}-3}nnn/${accession_code}/suppl/${accession_code}%5FBC${patient_id}.matrix.tar.gz" \
        -P "$data_dir"

    # Extract the files from the tar to dataset directory
    tar -xvf  "$data_dir/${accession_code}_BC${patient_id}.matrix.tar.gz" -C $dataset_dir
    rm "$data_dir/${accession_code}_BC${patient_id}.matrix.tar.gz"
done