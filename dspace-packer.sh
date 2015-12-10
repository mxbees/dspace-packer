#!/bin/bash

#sudo python xlsx2csv/xlsx2csv.py -e -d "|" xls_sample.xlsx sample.csv #don't forget to swap these out for CLI args $1 and $2

csv='sample2.csv'
field_number=$(head -n 1 $csv | awk -F'|' '{print NF-1}')
field_headers=$(head -n 1 $csv)
objects='test-files'
no_objects=$(ls -1 $objects | wc -l)
c1=1
c2=1
c3=1
id=$( ls $objects | xargs -I{} basename {} .pdf )
#mkdir /tmp/dspace
sed 1,1d $csv > /tmp/dspace/no_headers.csv

#make packages
make_simple_archive_format_package () {
ls $objects > /tmp/dspace/objects.txt
while read line
do
    id=$(basename $line .pdf)
    mkdir record.$id
    cp $objects/$line record.$id
    echo $line > record.$id/contents
done < /tmp/dspace/objects.txt
}

make_dc_record () {
OLDIFS=$IFS
IFS='|'
for j in $( ls $objects ) 
do
    while read -r $field_headers
    do
        echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > record.$identifier/dublin_core.xml
        echo "<dublin_core>" >> record.$identifier/dublin_core.xml
        printf '%b\n' "  <dcvalue qualifier=\"none\" element=\"title\">$title</dcvalue>" >> record.$identifier/dublin_core.xml
        printf '%b\n' "  <dcvalue qualifier=\"author\" element=\"contributor\">$author</dcvalue>" >> record.$identifier/dublin_core.xml
        printf '%b\n' "  <dcvalue element=\"contributor\" qualifier=\"advisor\">$advisor</dcvalue>" >> record.$identifier/dublin_core.xml
        printf '%b\n' "  <dcvalue qualifier=\"issued\" element=\"date\">$year</dcvalue>" >> record.$identifier/dublin_core.xml
        printf '%b\n' "  <dcvalue qualifier=\"none\" element=\"identifier\">$identifier</dcvalue>" >> record.$identifier/dublin_core.xml
        printf '%b\n' "  <dcvalue qualifier=\"citation\" element=\"identifier\">$citation</dcvalue>" >> record.$identifier/dublin_core.xml
        printf '%b\n' "  <dcvalue qualifier=\"abstract\" element=\"description\">$abstract</dcvalue>" >> record.$identifier/dublin_core.xml
        printf '%b\n' "  <dcvalue qualifier=\"none\" element=\"type\">$type</dcvalue>" >> record.$identifier/dublin_core.xml
        echo "</dublin_core>" >> record.$identifier/dublin_core.xml
    done < /tmp/dspace/no_head.csv
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

#make_simple_archive_format_package
make_dc_record
clean_ampersands
