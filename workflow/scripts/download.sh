 #!/bin/bash
set -u
set -o pipefail
list_of_files='links.txt'

links_arrays=()
while IFS= read -r link || [[ -n "$link" ]]; do
    links_arrays+=("$link")
done < "$list_of_files"

if [ ! -f "$list_of_files" ]; then
echo "You need to include a list of links of files to download in a links.txt file"
fi

for link in "${links_arrays[@]}"; do
    if [[ -z "$link" ]]; then
    continue
    fi
   file_name=$(basename "$link")
   file_name="${file_name%%\?*}"
   if [[ "$file_name" == *".fastq.gz" ]]; then
       out_dir="results/data"
   elif [[ "$file_name" == *".fasta" ]]; then
       out_dir="results/ref"
    else
    continue
   fi


   if [ ! -d "$out_dir" ]; then 
   mkdir -p "$out_dir"
   fi

    if [[ "$link" == ftp://* ]]; then
        wget --tries=3 --timeout=30 -q -nc -O "$out_dir/${file_name}" "${link}" 2>> download.log
    else
        wget --tries=3 --timeout=30 -q -O "$out_dir/${file_name}" "${link}" 2>> download.log
    fi

   if [ $? -ne 0 ] ; then
   echo "Error downloading $link. Check whether you input the correct link and try again" >> download.log
   fi
done

for file in results/data/*.fastq.gz; do
   if 
   [[ "$file" == *"_1.fastq.gz" && "$file" != *"_R1.fastq.gz" ]]; then
   r1_corrected="${file/_1.fastq.gz/_R1.fastq.gz}"
   mv "$file" "$r1_corrected"
   elif
   [[ "$file" == *"_2.fastq.gz" && "$file" != *"_R2.fastq.gz" ]]; then
   r2_corrected="${file/_2.fastq.gz/_R2.fastq.gz}"
   mv "$file" "$r2_corrected"
   fi
done
