#!/usr/bin/env python
from pathlib import Path

OUTPATH = "/scratch/user/s4543064/Xiaohan_Summer_Research/test"
SCRIPTPATH = str(Path(OUTPATH) / "scripts")
RDM = "Q6104"
CROUT = f"/QRISdata/{RDM}/cellranger"


def main():
    """Create a job script."""
    samples = [
        "SRR14800536",
        "SRR14800535",        
    ]

    for sample in samples:
        fh1 = open(Path(OUTPATH) / "jobs" / f"{sample}_cellranger.sh", "w")
        fh1.close()
        fh = open(Path(OUTPATH) / "jobs" / f"{sample}_cellranger.sh", "w")
        headers = [
            "#!/bin/bash\n",
            "#SBATCH --nodes=1\n",
            "#SBATCH --ntasks-per-node=1\n",
            "#SBATCH --cpus-per-task=64\n",
            "#SBATCH --mem=256G\n",
            f"#SBATCH --job-name={sample}_cellranger\n",
            "#SBATCH --time=24:00:00\n",
            "#SBATCH --partition=general\n",
            "#SBATCH --account=a_kelvin_tuong\n",
            f"#SBATCH -o log/{sample}_cellranger.o\n",
            f"#SBATCH -e log/{sample}_cellranger.e\n",
            "### ~~~ job script below ~~~ ###\n",
            "\n",
            "export PATH=/home/s4543064/cellranger-7.2.0:$PATH\n\n"
            "cd $TMPDIR\n",
            "mkdir $TMPDIR/fastq\n\n",
            f"mkdir $TMPDIR/fastq/{sample}\n\n",
            "# make the meta.csv files for running cellranger\n",
            f"python {SCRIPTPATH}/make_meta.py --folder $TMPDIR --sample {sample}\n\n",
        ]
        headers += [
            f"rsync -azvhP --no-perms --no-owner --no-group /QRISdata/{RDM}/Xiaohan/1_Datasets/PRJNA737188/{sample}_*.fastq $TMPDIR/fastq/{sample}/\n",
            f"python {SCRIPTPATH}/convert_fastq_name.py --folder $TMPDIR/fastq/{sample}\n",
            
        ]

        METAPATH = str(Path(OUTPATH) / "metadata" / f"{sample}.csv")
        cellranger = [
            "# run cellranger\n",
            f"cellranger count --id={sample} \\\n",
            f"       --csv={METAPATH} \\\n",
            "       --localcores=64 \\\n",
            "       --localmem=256\n\n",
        ]
        cellranger += [
            f"rsync -azvhP --no-perms --no-owner --no-group $TMPDIR/{sample} {CROUT}/out\n",
        ]
        new_file_contents = "".join(headers + cellranger)
        fh.write(new_file_contents)
        fh.close()


if __name__ == "__main__":
    (Path(CROUT) / "out").mkdir(parents=True, exist_ok=True)
    (Path(CROUT) / "fastq").mkdir(parents=True, exist_ok=True)
    (Path(OUTPATH) / "jobs" / "log").mkdir(parents=True, exist_ok=True)
    main()
