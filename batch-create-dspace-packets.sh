#!/bin/bash

#sudo python xlsx2csv/xlsx2csv.py -e -d "|" xls_sample.xlsx sample.csv #don't forget to swap these out for CLI args $1 and $2

field_number=$(head -n 1 sample.csv | awk -F'|' '{print NF-1}')
field_headers=$(head -n 1 sample.csv)
objects='test-files/'

#echo $field_headers
#echo $no_headers
for i in $(ls $objects)
do
    COUNTER=1
    while [ $COUNTER -le $field_number ]
    do
        cut -d'|' -f$COUNTER sample.csv | tail -n +2
        #echo $COUNTER
        COUNTER=$((COUNTER+1))
    done
done
#sed ':a;N;$!ba;s/\n/ /g'

#tr '\n' ' ' < input_filename
