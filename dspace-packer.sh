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
sed 1,1d $csv > /tmp/dspace/no_head.csv

#make packages
package () {
ls $objects > /tmp/dspace/objects.txt
while read line
do
    id=$(basename $line .pdf)
    mkdir record.$id
    cp $objects/$line record.$id
    echo $line > record.$id/contents
done < /tmp/dspace/objects.txt
}

populate () {
OLDIFS=$IFS
IFS='|'
for j in $( ls $objects ) 
do
while read $field_headers
do
    echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > record.$identifier/dublin_core.xml
    echo "<dublin_core>" >> record.$identifier/dublin_core.xml
    echo -e "  <dcvalue qualifier=\"none\" element=\"title\">$title</dcvalue>" >> record.$identifier/dublin_core.xml
    echo "  <dcvalue qualifier=\"author\" element=\"contributor\">$author</dcvalue>" >> record.$identifier/dublin_core.xml
    echo "  <dcvalue element=\"contributor\" qualifier=\"advisor\">$advisor</dcvalue>" >> record.$identifier/dublin_core.xml
    echo "  <dcvalue qualifier=\"issued\" element=\"date\">$year</dcvalue>" >> record.$identifier/dublin_core.xml
    echo "  <dcvalue qualifier=\"none\" element=\"identifier\">$identifier</dcvalue>" >> record.$identifier/dublin_core.xml
    echo "  <dcvalue qualifier=\"citation\" element=\"identifier\">$citation</dcvalue>" >> record.$identifier/dublin_core.xml
    echo $abstract #"  <dcvalue qualifier=\"abstract\" element=\"description\">$abstract</dcvalue>" #>> record.$identifier/dublin_core.xml
    echo "  <dcvalue qualifier=\"none\" element=\"type\">$type</dcvalue>" >> record.$identifier/dublin_core.xml
    echo "</dublin_core>" >> record.$identifier/dublin_core.xml


done < /tmp/dspace/no_head.csv
done
IFS=$OLDIFS
}  

#package
populate


