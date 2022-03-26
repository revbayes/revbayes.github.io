#!/bin/bash

# convert all pdfs to pngs
for file in figures/*.pdf
do
  echo $file
  convert -density 500 $file "${file%.pdf}.png"
done
