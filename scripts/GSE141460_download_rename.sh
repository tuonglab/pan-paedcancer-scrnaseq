#!/bin/bash

accession_code="GSE141460"
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

# Check what type of files included in the dataset
if find "$dataset_dir" -maxdepth 1 -type f -name "*features*" | grep -q .; then # it's features type
    echo "It's features.tsv.gz"
else
    # Check if it's genes type
    if find "$dataset_dir" -maxdepth 1 -type f -name "*genes*" | grep -q .; then
        gunzip "$dataset_dir"/*.gz | rm *.gz
    else 
        echo "It may be txt type"
        exit 1 # indicate an "error"
    fi
fi 

### The dataset includes a .tar.gz file for each sample

# Create directories for each sample and move corresponding files
for tar_file in "${dataset_dir}"/*; do
    sample=$(basename "${tar_file}" | sed 's/_10X.tar.gz//') # dot . represents any single char and * indicates any occurrence time
    echo ${tar_file}
    mkdir -p "${dataset_dir}/${sample}"
    tar -xvf  ${tar_file} -C "${dataset_dir}/${sample}" --strip-components=1
    rm ${tar_file}
done