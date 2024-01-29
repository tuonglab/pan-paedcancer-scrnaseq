#!/usr/bin/env python
import argparse
import os
from pathlib import Path

OUTPATH = "/scratch/project/tcr_neoantigen/misc/ben"
REFPATH = "/scratch/project/tcr_neoantigen/resources/cellranger_references"


def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--folder",
        help=("path to folder to convert."),
    )
    parser.add_argument(
        "--sample",
        help=("name of sample."),
    )
    args = parser.parse_args()
    return args


def main():
    """Create a job script."""
    args = parse_args()
    sample_dict = {
        "Ankle_CD45plus_TCRminus_CSP": "Ankle_CD45plus_TCRminus_CSP_22FMHWLT3_CTGCCTGGGT-GACCAATAGC",
        "Ankle_CD45plus_TCRminus_GEX": "Ankle_CD45plus_TCRminus_GEX_22FMHWLT3_TTGCCCGTGC-GCGTGAGATT",
        "Ankle_CD45plus_TCRplus_CSP": "Ankle_CD45plus_TCRplus_CSP_22FMHWLT3_TCAAAGGGTT-GATTACTGAG",
        "Ankle_CD45plus_TCRplus_GEX": "Ankle_CD45plus_TCRplus_GEX_22FMHWLT3_CGGCTGGATG-TGATAAGCAC",
        "Ankle_CD45plus_TCRplus_TCR": "Ankle_CD45plus_TCRplus_TCR_22FMHWLT3_TGTAGTCATT-CTTGATCGTA",
        "BALB_MLN_CD4_CSP": "BALB_MLN_CD4_CSP_22FMHWLT3_TCTCGAATGT-ACGATCGCGA",
        "BALB_MLN_CD4_GEX": "BALB_MLN_CD4_GEX_22FMHWLT3_GAGAGGATAT-TTGAAATGGG",
        "BALB_MLN_CD4_TCR": "BALB_MLN_CD4_TCR_22FMHWLT3_TTCACACCTT-TAGTGTACAC",
        "BALB_MLN_CD8_CSP": "BALB_MLN_CD8_CSP_22FMHWLT3_TGGGTGCACA-CATGCATCAT",
        "BALB_MLN_CD8_GEX": "BALB_MLN_CD8_GEX_22FMHWLT3_CCCACCACAA-ACCTCCGCTT",
        "BALB_MLN_CD8_TCR": "BALB_MLN_CD8_TCR_22FMHWLT3_GAGACGCACG-CTATGAACAT",
        "BALB_PLN_CD4_CSP": "BALB_PLN_CD4_CSP_22FMHWLT3_CAGGCGAATA-CCCTTTACCG",
        "BALB_PLN_CD4_GEX": "BALB_PLN_CD4_GEX_22FMHWLT3_AAGATTGGAT-AGCGGGATTT",
        "BALB_PLN_CD4_TCR": "BALB_PLN_CD4_TCR_22FMHWLT3_GTCCCATCAA-CGAACGTGAC",
        "BALB_PLN_CD8_CSP": "BALB_PLN_CD8_CSP_22FMHWLT3_CTACGACTGA-CATCGCCCTC",
        "BALB_PLN_CD8_GEX": "BALB_PLN_CD8_GEX_22FMHWLT3_AAGGGCCGCA-CTGATTCCTC",
        "BALB_PLN_CD8_TCR": "BALB_PLN_CD8_TCR_22FMHWLT3_CCGGCAACTG-CGGTTTAACA",
        "SKG_CD4_CSP": "SKG_CD4_CSP_22FMHWLT3_TTGCGGGACT-TGAGGATCGC",
        "SKG_CD4_GEX": "SKG_CD4_GEX_22FMHWLT3_CGTCCACCTG-CATTCATGAC",
        "SKG_CD4_TCR": "SKG_CD4_TCR_22FMHWLT3_CTCCTTTAGA-GACATAGCTC",
        "SKG_CD8_CSP": "SKG_CD8_CSP_22FMHWLT3_TCACGTTGGG-CTTTGCTCCA",
        "SKG_CD8_GEX": "SKG_CD8_GEX_22FMHWLT3_TCCGGGACAA-GTGAATGCCA",
        "SKG_CD8_TCR": "SKG_CD8_TCR_22FMHWLT3_AATGTATCCA-AATGAGCTTA",
    }

    fh1 = open(Path(OUTPATH) / "metadata" / f"{args.sample}.csv", "w")
    fh1.close()
    fh = open(Path(OUTPATH) / "metadata" / f"{args.sample}.csv", "w")
    content = [
        "[gene-expression]\n" f"reference,{REFPATH}/refdata-gex-balbcj-2023-A\n\n"
    ]
    gex = sample_dict[f"{args.sample}_GEX"]
    csp = sample_dict[f"{args.sample}_CSP"]
    content += ["[feature]\n"]
    content += [
        f"reference,{REFPATH}/TotalSeq_C_Mouse_Universal_Cocktail_199903_Antibody_reference_UMI_counting_kt_with_hto.csv\n\n"
    ]
    content += [
        "[libraries]\n"
        "fastq_id,fastqs,lanes,feature_types\n"
        f"{gex},{args.folder}/fastq/{args.sample}_GEX,3|4,Gene Expression\n"
        f"{csp},{args.folder}/fastq/{args.sample}_CSP,3|4,Antibody Capture\n"
    ]
    if args.sample != "Ankle_CD45plus_TCRminus":
        tcr = sample_dict[f"{args.sample}_TCR"]
        content += [f"{tcr},{args.folder}/fastq/{args.sample}_TCR,3|4,VDJ-T\n"]
    fh.write("".join(content))
    fh.close()


if __name__ == "__main__":
    os.makedirs(Path(OUTPATH) / "metadata", exist_ok=True)
    main()
