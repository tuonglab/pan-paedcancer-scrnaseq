#!/bin/bash



# Get the directory specified by the user
DIRECTORY=$1

echo "Starting decompression of .gz files in $DIRECTORY..."

# Counter for decompressed files
count=0

# Loop through all .gz files in the current directory and decompress them
for file in "$DIRECTORY"/*.gz; do
    if [ -f "$file" ]; then
        echo "Decompressing $file..."
        gunzip "$file"
        let count++
    fi
done

# Check if any files were decompressed
if [ $count -eq 0 ]; then
    echo "No .gz files found in $DIRECTORY."
else
    echo "Decompression complete. $count files were decompressed and removed."
fi