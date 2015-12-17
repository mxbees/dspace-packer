#!/bin/bash

#sudo python xlsx2csv/xlsx2csv.py -e -d "@" xls_sample.xlsx sample.csv #don't forget to swap these out for CLI args $1 and $2

csv='telegram_sample.csv'
field_number=$(head -n 1 $csv | awk -F'|' '{print NF-1}')
#field_headers=$(head -n 1 $csv)
#echo $field_headers
objects='test-files'
no_objects=$(ls -1 $objects | wc -l)
c1=1
c2=1
c3=1
#mkdir /tmp/dspace
sed 1,1d $csv > /tmp/dspace/no_headers.csv

#make packages
make_simple_archive_format_package () {
ls $objects > /tmp/dspace/objects.txt
while read line
do
    id=$(basename $line .jpg)
    mkdir record.$id
    cp $objects/$line record.$id
    echo $line > record.$id/contents
done < /tmp/dspace/objects.txt
}

make_dc_record () {
OLDIFS=$IFS
IFS='@'
head -n 1 $csv > /tmp/dspace/field_headers.csv
for j in $( ls $objects ) 
do
    while read -r $(cat /tmp/dspace/field_headers.csv)
    do
        echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > record.$dc_identifier/dublin_core.xml
        echo "<dublin_core>" >> record.$dc_identifier/dublin_core.xml
        printf '%b\n' "  <dcvalue qualifier=\"none\" element=\"title\">$dc_title</dcvalue>" >> record.$dc_identifier/dublin_core.xml
        echo "</dublin_core>" >> record.$dc_identifier/dublin_core.xml
    done < /tmp/dspace/no_headers.csv
done
IFS=$OLDIFS
}

clean_ampersands () {
find record.* -name dublin_core.xml > /tmp/dspace/dc_records.txt
while read line
do
    sed -i 's/&/&amp;/g' $line
done < /tmp/dspace/dc_records.txt
}
head -n 1 $csv > /tmp/dspace/field_headers.txt
#make_simple_archive_format_package
make_dc_record
#clean_ampersands
