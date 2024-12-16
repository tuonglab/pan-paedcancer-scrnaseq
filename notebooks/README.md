# Notebooks

This directory contains the Jupyter notebooks used in the project.

## Folder Structure

```bash
notebooks/
├── 01_count_matrix_extraction/ 
│   ├── DATASET_ACCESSION_CODE.ipynb  # Extract count matrices for this scRNA-seq dataset
├── 02_meta_analysis/ 
│   ├── 01_preprocessing.ipynb       # Concatenate count matrices from all datasets into one
│   ├── 02_integration.ipynb         # Perform scVI integration
│   ├── 03_annotation.ipynb          # Categorize cancer type information into 3 hierarchies and perform CellTypist annotation
│   ├── 04_figures.ipynb             # Plot figures for the manuscript
```