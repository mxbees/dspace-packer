#!/bin/bash

new_csv=$( basename $1 .xlsx )
python xlsx2csv/xlsx2csv.py -e -d "^" $1 $new_csv.csv

csv="$new_csv.csv"
objects='test-files'

#make packages
make_simple_archive_format_package () {
for i in $objects/*
do
    id=$(basename $i .pdf)
    mkdir record.$id
    cp $i record.$id
    echo $line > record.$id/contents
done 
}

make_dc_header () {
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > record.$dc_identifier/dublin_core.xml
echo "<dublin_core>" >> record.$dc_identifier/dublin_core.xml
}

make_dc_footer () {
echo "</dublin_core>" >> record.$dc_identifier/dublin_core.xml
}

make_dc_body () {
OLDIFS=$IFS
IFS='^'
header_row=$(head -n1 $csv)
sed 1,1d $csv > /tmp/no_headers.csv
read -a all_headers x <<< "$header_row"
make_dc_header
c1=1

for header in "${all_headers[@]}"; do
    field=$(grep "$dc_identifier" $csv | cut -d'^' -f$c1)
    element=$(echo "$header" | cut -d'_' -f1)
    qualifier=$(echo "$header" | cut -d'_' -f2)
    printf '%b\n' "<dcvalue element=\"$element\" qualifier=\"$qualifier\">$field</dcvalue>" >> record.$dc_identifier/dublin_core.xml
    c1=$((c1+1))
done
make_dc_footer
IFS=$OLDIFS
}

make_dc_record () {
for i in $objects/*
do
    dc_identifier=$( basename $i .pdf )
    make_dc_body
done
}

clean_ampersands () {
for i in record.*/dublin_core.xml 
do
    sed -i 's/&/&amp;/g' $i
done
}

make_simple_archive_format_package
make_dc_record
clean_ampersands
