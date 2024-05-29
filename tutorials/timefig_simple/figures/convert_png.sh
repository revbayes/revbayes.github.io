for file in $(ls ./*.pdf); do
    echo "Processing ${file}..."
    convert -density 150 -depth 8 -quality 85 "${file}" "${file%.*}.png"
done
