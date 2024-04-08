#!/bin/bash

# From project root
# Usage: bash scripts/geo_get.sh GSE123456

accession_code=$1

wget -e robots=off -nH -nd \
    "ftp://ftp.ncbi.nlm.nih.gov/geo/series/${accession_code:0:${#accession_code}-3}nnn/${accession_code}/suppl/${accession_code}_RAW.tar" \
    -P data

mkdir "data/${accession_code}_RAW/"

tar -xvf  data/${accession_code}_RAW.tar -C data/${accession_code}_RAW
rm data/${accession_code}_RAW.tar

tree -o trees/${accession_code}_tree.txt -J  data/${accession_code}_RAW

exit