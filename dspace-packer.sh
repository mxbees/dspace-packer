#!/bin/bash

#sudo python xlsx2csv/xlsx2csv.py -e -d "^" xls_sample.xlsx sample.csv #don't forget to swap these out for CLI args $1 and $2

csv='rs_sample.csv'
header_row=$(head -n1 $csv)
#echo $field_headers
objects='test-files'

#mkdir /tmp/dspace
sed 1,1d $csv > /tmp/dspace/no_headers.csv

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
read -a all_headers x <<< "$header_row"
while read -a row; do
    c1=0
    make_dc_header
    for header in "${all_headers[@]}"; do
        element=$(echo "$header" | cut -d'_' -f1)
        qualifier=$(echo "$header" | cut -d'_' -f2)
        printf '%b\n' "<dcvalue element=\"$element\" qualifier=\"$qualifier\">${row[$c1]}<dcvalue>" >> record.$dc_identifier/dublin_core.xml
        c1=$((c1+1))
    done
    make_dc_footer
done < /tmp/dspace/no_headers.csv
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
find record.* -name dublin_core.xml > /tmp/dspace/dc_records.txt
#while read line
for i in $(find record.* -name dublin_core.xml)
do
    sed -i 's/&/&amp;/g' $i
done #< /tmp/dspace/dc_records.txt
}

make_simple_archive_format_package
make_dc_record
clean_ampersands
