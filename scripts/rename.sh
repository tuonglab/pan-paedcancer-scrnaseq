#!/bin/bash

# Loop through all files that contain at least one underscore.
for file in *; do
  # Skip if it's a directory.
  [ -d "$file" ] && continue

  # Check if the file name contains an underscore.
  if [[ "$file" == *_* ]]; then
    # Extract the prefix by taking everything before the last underscore.
    prefix="${file%_*}"

    # Create a directory for the prefix if it doesn't already exist.
    mkdir -p "$prefix"

    # Extract the part after the last underscore for the new name.
    new_name="${file##*_}"

    # Move and rename the file into its prefix directory.
    mv "$file" "$prefix/$new_name"
  fi
done
