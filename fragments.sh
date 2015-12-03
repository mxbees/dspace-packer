for j in $(ls /tmp/dspace/*.txt)
    do
        while [ $c3 -le $field_number ]
        do

        line=$(awk -v c=$c3 'NR==c{print; exit}' $j)
        echo $j $line
        
      #      for h in $(ls /tmp/dspace/*.txt); do
      #      h=$( basename $j .txt )
       #     if [ "$y" = "identifier" ]
            
       #     then
      #          line=$(awk -v c=$c3 'NR==c{print; exit}' $h)
       #         echo $j $line
       #     fi
               # echo "    <dcvalue element=\"identifier\" qualifier=\"none\">$line</dcvalue>" #>> record.$object_id/dublin_core.xml
         #   fi
        #    if [ "$y" = adviser ]
        #    then
        #        line=$(awk -v c=$c3 'NR==c{print; exit}' $j)
         #       echo $j $line
         #   fi
            #c3=$((c3+1))
           # done
        

        
        
        c3=$((c3+1))
  done
        #if [ "$y" = "abstract" ]
        #then
        #while read line
        #do
        #    if [ "$object_id" = "$line" ]
        #    then
                #echo "  <dcvalue element=\"description\" qualifier=\"abstract\">$line</dcvalue>" #>> record.$object_id/dublin_core.xml
       #     fi
       # done < $j
        #fi
        
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
