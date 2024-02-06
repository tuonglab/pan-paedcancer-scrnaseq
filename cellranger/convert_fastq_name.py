import argparse
import os
import re
from pathlib import Path


def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--folder",
        help=("path to folder to convert."),
    )
    args = parser.parse_args()
    return args


def modify_file_names(input_directory):
    for filename in os.listdir(input_directory):
        if filename.endswith(".fastq.gz"):
            # Extract relevant parts from the original filename
            match = re.match(r"(.+)_L(\d+)_R(\d+)\.fastq\.gz", filename)
            if match:
                sample_name, lane_number, read_type = match.groups()
                # Construct the new filename
                new_filename = f"{sample_name}_S1_L{lane_number.zfill(3)}_R{read_type}_001.fastq.gz"
                # Construct the full paths for renaming
                old_path = os.path.join(input_directory, filename)
                new_path = os.path.join(input_directory, new_filename)
                # Rename the file
                os.rename(old_path, new_path)
                print(f"Renamed: {old_path} -> {new_path}")


def main():
    args = parse_args()
    modify_file_names(args.folder)


if __name__ == "__main__":
    main()
