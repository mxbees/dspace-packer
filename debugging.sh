#!/bin/bash
csv=sample2.csv
field_number=$(head -n 1 $csv | awk -F'|' '{print NF-1}')
field_headers=$(head -n 1 $csv)
objects='test-files/'
no_objects=$(ls -1 $objects | wc -l)
c1=1
c2=1
c3=1
id=$( ls $objects | xargs -I{} basename {} .pdf )

while read $field_headers
do
    echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > record.$id/dublin_core.xml
    echo "<dublin_core>" >> record.$id/dublin_core.xml
    echo "  <dcvalue qualifier=\"none\" element=\"title\">$title</dcvalue" >> record.$id/dublin_core.xml
    echo "  <dcvalue qualifier=\"author\" element=\"contributor\">$author</dcvalue>" >> record.$id/dublin_core.xml
    echo "  <dcvalue element=\"contributor\" qualifier=\"advisor\">$advisor</dcvalue>" >> record.$id/dublin_core.xml
    echo "  <dcvalue qualifier=\"issued\" element=\"date\">$year</dcvalue" >> record.$id/dublin_core.xml
    echo "  <dcvalue qualifier=\"none\" element=\"identifier\">$identifier</dcvalue>" >> record.$id/dublin_core.xml
    echo "  <dcvalue qualifier=\"citation\" element=\"identifier\">$citation</dcvalue>" >> record.$id/dublin_core.xml
    echo "  <dcvalue qualifier=\"abstract\" element=\"description\">$abstract</dcvalue>" >> record.$id/dublin_core.xml
    echo "  <dcvalue qualifier=\"none\" element=\"type\">$type</dcvalue>" >> record.$id/dublin_core.xml
    echo "</dublin_core>" >> record.$id/dublin_core.xml
done < /tmp/dspace/no_head.csv


