General scripts for running cellranger on Bunya.

## Setup/Download Cellranger and references

<!-- For the total-seq kit, we also need to provide the feature barcode file. I uploaded the file from my computer using `rsync`. So before heading off to bunya, do this if you haven't done so already.
```bash
# From terminal on local computer
rsync -azvhP /Users/uqztuong/Documents/_Projects/Thomas/ben/TotalSeq_C_Mouse_Universal_Cocktail_199903_Antibody_reference_UMI_counting_kt.csv uqztuong@bunya.rcc.uq.edu.au:/scratch/project/tcr_neoantigen/resources/cellranger_references/
``` -->

Then, login to bunya and download the cellranger software and references.
```bash
# On Bunya
cd /scratch/project/tcr_neoantigen/softwares
# cellranger
wget -O cellranger-7.2.0.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-7.2.0.tar.gz?Expires=1702403946&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA&Signature=AYYZ7GN~EEGWLhEz9eF-CGYltFJbhLg~FTeo~pSQ18jFD2mmEbPauvrmCJ7KkgQZXNMdxzk1Zk~rHVXtCm1t7tfgD5wcLzeL--RvozJTFZ5EwKOwo7eFnd9GtT20N9XocAHbuhA11SVB2IGNtI2SeVywM5nef7H32JJnzWwOpmBNMPrbbGaPSLujGCPDGl-TpX6pGFxmaxVbZ6l3ytsYAIv89Vsh8jtCHWY05WBqrDWBNjkogKJpBoHMzRgMkWIQy7uOhodgByW96WYFtfArtV3exhIGxvKjJSqZZ4CJo56Lz7qpz295hFVHzkNJ0HB5NxYxSArk~mPLKSMtzqcPmg__"
tar -xzvf cellranger-7.2.0.tar.gz
rm cellranger-7.2.0.tar.gz

# download human reference from 10x website
```

### Automate 1) creating the metadata file for running cellranger, 2) writing the bash scripts to submit as jobs
From here onwards, the general process with bunya is that we copy the files from RDM to `$TMPDIR` and then do our stuff there and then copy back to RDM to store.
We repeat this step everytime we `sbatch` something.
```bash
cd /scratch/project/tcr_neoantigen/misc/ben/scripts
python 01_make_jobscripts.py
```

### submit the jobs
```bash
cd /scratch/project/tcr_neoantigen/misc/ben/jobs

sbatch Ankle_CD45plus_TCRminus_cellranger.sh
sbatch Ankle_CD45plus_TCRplus_cellranger.sh
sbatch BALB_MLN_CD4_cellranger.sh
sbatch BALB_MLN_CD8_cellranger.sh
sbatch BALB_PLN_CD4_cellranger.sh
sbatch BALB_PLN_CD8_cellranger.sh
sbatch SKG_CD4_cellranger.sh
sbatch SKG_CD8_cellranger.sh
```

### Preprocess tcr

Run `dandelion` preprocessing on the tcr.
```bash
cd /scratch/project/tcr_neoantigen/misc/ben/scripts
python 02_prepare_for_dandelion_preprocessing.py

cd /scratch/project/tcr_neoantigen/misc/ben/jobs
sbatch dandelion.sh
```

### Copy the cellranger output files to a simplified folder on RDM

```bash
cd /scratch/project/tcr_neoantigen/misc/ben/scripts
python 03_copy_relevant_files_for_downstream.py
```

### Demultiplex hashtags

Use `hashsolo` to demultiplex the hashtags.
```bash
cd /scratch/project/tcr_neoantigen/misc/ben/scripts
python 04_write_hashsolo_bash.py

cd /scratch/project/tcr_neoantigen/misc/ben/jobs
sbatch hashsolo.sh
```

### transfer data back to RDM
Use `rsync`

```bash
rsync -azvhP  --no-perms --no-owner --no-group /scratch/project/tcr_neoantigen/misc/ben/jobs /QRISdata/Q6551/singlecell_run2
rsync -azvhP  --no-perms --no-owner --no-group /scratch/project/tcr_neoantigen/misc/ben/metadata /QRISdata/Q6551/singlecell_run2
rsync -azvhP  --no-perms --no-owner --no-group /scratch/project/tcr_neoantigen/misc/ben/scripts /QRISdata/Q6551/singlecell_run2
```
The files you want are in the `out/cellranger_out` folder.

Also transfer the cellranger resources and store on RDM.
```bash
# just incase 
mkdir -p /QRISdata/Q6551/singlecell_run2/resources
rsync -azvhP --no-perms --no-owner --no-group /scratch/project/tcr_neoantigen/resources/cellranger_references/refdata-cellranger-vdj-balbcj-alts-ensembl-7.2.0 /QRISdata/Q6551/singlecell_run2/resources
rsync -azvhP --no-perms --no-owner --no-group /scratch/project/tcr_neoantigen/resources/cellranger_references/refdata-gex-balbcj-2023-A /QRISdata/Q6551/singlecell_run2/resources
rsync -azvhP --no-perms --no-owner --no-group /scratch/project/tcr_neoantigen/resources/cellranger_references/TotalSeq_C_Mouse_Universal_Cocktail_199903_Antibody_reference_UMI_counting_kt_with_hto.csv /QRISdata/Q6551/singlecell_run2/resources
```

### Ready to analyse!
