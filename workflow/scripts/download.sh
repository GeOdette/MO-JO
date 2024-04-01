list_of_files='links.csv'

links_arrays=()
while IFS= read -r link || [[ -n "$link" ]]; do
    links_arrays+=("$link")
done < "$list_of_files"

for link in "${links_arrays[@]}"; do
   file_name=$(basename "$link")
   file_name="${file_name%%\?*}"
   if [[ "$file_name" == *".fastq.gz" ]]; then
       out_dir="results/data"
   elif [[ "$file_name" == *".fasta" ]]; then
       out_dir="results/ref"
   fi
   mkdir -p "$out_dir"

   wget -q -O "$out_dir/${file_name}" "${link}"
done