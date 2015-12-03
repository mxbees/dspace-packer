#!/bin/bash

#sudo python xlsx2csv/xlsx2csv.py -e -d "|" xls_sample.xlsx sample.csv #don't forget to swap these out for CLI args $1 and $2

csv=sample2.csv
field_number=$(head -n 1 $csv | awk -F'|' '{print NF-1}')
field_headers=$(head -n 1 $csv)
objects='test-files/'
no_objects=$(ls -1 $objects | wc -l)
c1=1
c2=1
c3=1

#mkdir /tmp/dspace

for i in $(ls $objects)
do
    #make packages
    id=$( basename $i .pdf )
    mkdir record.$id
    cp $objects/$i record.$id/
    echo $i > record.$id/contents
    echo '<?xml version="1.0" encoding="UTF-8"?>' > record.$id/dublin_core.xml
    echo '<dublin_core>' >> record.$id/dublin_core.xml
    #split metadata
    while [ $c1 -le $field_number ]
    do
        x=$(head -n 1 $csv | awk -v r=$c2 'BEGIN { FS = "|" } ; {print $r}')
        cut -d'|' -f$c2 sample.csv | tail -n +2 > /tmp/dspace/$x.txt
    c1=$((c1+1))
    c2=$((c2+1))
    done
    
    for j in $(ls /tmp/dspace/*.txt)
    do
        y=$( basename $j .txt )
        #while [ $c3 -le $no_objects ]
        
        if [ "$y" = "identifier" ]
        then
        while read line
        do
            if [ "$id" = "$line" ]
            then
                echo "    <dcvalue element=\"identifier\" qualifier=\"none\">$line</dcvalue>" >> record.$id/dublin_core.xml
            fi
        done < $j
        fi
        if [ "$y" = "abstract" ]
        then
        while read line
        do
            if [ "$id" = "$line" ]
            then
                echo "  <dcvalue element=\"description\" qualifier=\"abstract\">$line</dcvalue>" #>> record.$id/dublin_core.xml
            fi
        done < $j
        fi
        
    done
    echo '</dublin_core>' >> record.$id/dublin_core.xml
done



#            identifier=$(head -n $c3 /tmp/dspace/identifier.txt | tail -1)






#while read line
#        do
#            data=$(echo $line | cut -d'|' -f$COUNTER)
#            echo "  <dcvalue element=\"identifier\" qualifier=\"none\">$data</dcvalue>" #>> record.$id/dublin_core.xml
#            COUNTER=$((COUNTER+1))
#        done < sample.csv
#


#OLDIFS=$IFS
#IFS='|'
#[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
#while read one two three
#do
#	echo "Name : $one"
#	echo "DOB : $two"
#	echo "SSN : $three"
#done < $csv
#IFS=$OLDIFS

#        COUNTER=1
 #       while read line
  #      do
   #         data=$(echo $line | cut -d'|' -f$COUNTER)
     #       echo "  <dcvalue element=\"identifier\" qualifier=\"none\">$data</dcvalue>" >> record.$id/dublin_core.xml
    #        COUNTER=$((COUNTER+1))
      #  done < sample.csv

#echo $field_headers
#echo $no_headers


#sed ':a;N;$!ba;s/\n/ /g'

#tr '\n' ' ' < input_filename
