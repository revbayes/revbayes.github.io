#!/bin/bash

# run all the analyses
echo "running analyses"
bash tools/run_all.s

# make all the figures and convert to png
echo "making figures"
bash tools/make_figures.sh

echo "converting pdfs to pngs"
bash tools/convert_to_png.sh

# compress the files
echo "compressing files"
bash tools/compress_files.sh
