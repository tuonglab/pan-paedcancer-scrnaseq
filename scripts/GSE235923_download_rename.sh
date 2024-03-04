#!/bin/bash

accession_code="GSE235923"
data_dir="/scratch/user/s4543064/xiaohan-john-project/data"
dataset_dir="$data_dir/$accession_code"

mkdir $dataset_dir

# Download the dataset from GEO
wget -e robots=off -nH -nd \
    "ftp://ftp.ncbi.nlm.nih.gov/geo/series/${accession_code:0:${#accession_code}-3}nnn/${accession_code}/suppl/${accession_code}_RAW.tar" \
    -P "$data_dir"

# Extract the files from the tar to dataset directory
tar -xvf  "$data_dir/${accession_code}_RAW.tar" -C $dataset_dir
rm "$data_dir/${accession_code}_RAW.tar"

# Check what type of files included in the dataset
if find "$dataset_dir" -maxdepth 1 -type f -name "*features*" | grep -q .; then # it's features type
    echo "It's features.tsv.gz"
else
    # Check if it's genes type
    if find "$dataset_dir" -maxdepth 1 -type f -name "*genes*" | grep -q .; then
        gunzip "$dataset_dir"/*.gz | rm *.gz
    else 
        echo "It may be txt type"
    fi
fi 

# Create directories for each sample and move corresponding files
for file in "${dataset_dir}"/*_barcodes*; do
    sample=$(basename "${file}" | sed 's/_barcodes.*//') # dot . represents any single char and * indicates any occurrence time
    mkdir -p "${dataset_dir}/${sample}"
    mv ${dataset_dir}/${sample}_* ${dataset_dir}/${sample}
done

# Remove prefix from files within each sample directory
for sample_dir in "${dataset_dir}"/*; do
    sample=$(basename "${sample_dir}")
    for file in "${sample_dir}"/*; do
        file_name=$(basename "${file}" | sed "s/${sample}_//")
        mv "${file}" "${sample_dir}/${file_name}"
    done	
done
