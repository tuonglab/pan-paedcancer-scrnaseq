#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=256G
#SBATCH --job-name=SRR14800535_cellranger
#SBATCH --time=24:00:00
#SBATCH --partition=general
#SBATCH --account=a_kelvin_tuong
#SBATCH -o log/SRR14800535_cellranger.o
#SBATCH -e log/SRR14800535_cellranger.e
### ~~~ job script below ~~~ ###

export PATH=/scratch/project/tcr_neoantigen/softwares/cellranger-7.2.0/bin:$PATH

cd $TMPDIR
mkdir $TMPDIR/fastq

mkdir $TMPDIR/fastq/SRR14800535

# make the meta.csv files for running cellranger
# python /scratch/user/s4543064/Xiaohan_Summer_Research/test/scripts/make_meta.py --folder $TMPDIR --sample SRR14800535
cp /path/to/SRR14800535_1.fastq /path/to/SRR14800535_S1_L001_R1_001.fastq 
cp /path/to/SRR14800535_2.fastq /path/to/SRR14800535_S1_L001_R2_001.fastq 

gzip /path/to/SRR14800535_S1_L001_R1_001.fastq 
gzip /path/to/SRR14800535_S1_L001_R2_001.fastq 

rsync -azvhP --no-perms --no-owner --no-group /QRISdata/Q6104/Xiaohan/1_Datasets/PRJNA737188/SRR14800535_*.fastq.gz $TMPDIR/fastq/SRR14800535/
# run cellranger
cellranger count --id=SRR14800535 \
       --csv=/scratch/user/s4543064/Xiaohan_Summer_Research/test/metadata/SRR14800535.csv \
       --localcores=64 \
       --localmem=256

rsync -azvhP --no-perms --no-owner --no-group $TMPDIR/SRR14800535 /QRISdata/Q6104/cellranger/out
