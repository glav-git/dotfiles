#!/bin/bash

# Check if correct number of arguments provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <input.webp> <output.webm>"
    exit 1
fi

INPUT="$1"
OUTPUT="$2"

# Check if input file exists
if [ ! -f "$INPUT" ]; then
    echo "Error: Input file '$INPUT' not found"
    exit 1
fi

# Run ffmpeg command
# ffmpeg -loop 1 -i "$INPUT" -t 1 -c:v libvpx -an "$OUTPUT"
ffmpeg -i "$INPUT" -vf scale=512:512 -to 00:00:01 -c:v libvpx-vp9 -pix_fmt yuv420p -loop 1 "$OUTPUT"

