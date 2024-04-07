#!/bin/bash

username="uqjsaxo1"
accession_code="GSE235923"
data_dir="/scratch/user/s4543064/xiaohan-john-project/data"
dataset_dir="$data_dir/$accession_code"

rsync -azvh u/Users/(username)/Documents/GitHub/repo_name/data sername@bunya.rcc.uq.edu.au:/QRISdata/Q6104/SomeFolderContainingFilesYouWantToDoAnalysisOn/new_output 