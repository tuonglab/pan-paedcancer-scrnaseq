#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=256G
#SBATCH --job-name=SRR14800536_cellranger
#SBATCH --time=24:00:00
#SBATCH --partition=general
#SBATCH --account=a_kelvin_tuong
#SBATCH -o log/SRR14800536_cellranger.o
#SBATCH -e log/SRR14800536_cellranger.e
### ~~~ job script below ~~~ ###

export PATH=/home/s4543064/cellranger-7.2.0/bin:$PATH

cd $TMPDIR
mkdir $TMPDIR/fastq

mkdir $TMPDIR/fastq/SRR14800536

# make the meta.csv files for running cellranger
# python /scratch/user/s4543064/Xiaohan_Summer_Research/test/scripts/make_meta.py --folder $TMPDIR --sample SRR14800536

cp /QRISdata/Q6104/Xiaohan/1_Datasets/PRJNA737188/SRR14800536_1.fastq /QRISdata/Q6104/Xiaohan/1_Datasets/PRJNA737188/SRR14800536_S1_L001_R1_001.fastq 
echo 'I have created the SRR14800536_S1_L001_R1_001.fastq file'
cp /QRISdata/Q6104/Xiaohan/1_Datasets/PRJNA737188/SRR14800536_2.fastq /QRISdata/Q6104/Xiaohan/1_Datasets/PRJNA737188/SRR14800536_S1_L001_R2_001.fastq 
echo 'I have created the SRR14800536_S1_L001_R2_001.fastq file'

rsync -azvhP --no-perms --no-owner --no-group /QRISdata/Q6104/Xiaohan/1_Datasets/PRJNA737188/SRR14800536_*.fastq $TMPDIR/fastq/SRR14800536/
# run cellranger
cellranger count --id=SRR14800536 \
       --transcriptome=/home/s4543064/refdata-gex-GRCh38-2020-A \
       --fastqs=$TMPDIR/fastq/SRR14800536/ \
       --localcores=64 \
       --localmem=256

rsync -azvhP --no-perms --no-owner --no-group $TMPDIR/SRR14800536 /QRISdata/Q6104/Xiaohan/3_cellranger_outputs
