#!/bin/bash
c3=1
objects='test-files/'
no_objects=$(ls -1 $objects | wc -l)

#        if [ "$y" = "identifier" ]
 #       then
        while [ $c3 -le $no_objects ] 
        do
            line=$(awk -v c=$c3 'NR==c{print; exit}' /tmp/dspace/identifier.txt)
            #if [ "$id" = "$line" ]
            #then
                echo "    <dcvalue element=\"identifier\" qualifier=\"none\">$line</dcvalue>" #> record.$id/dublin_core.xml
            #fi
        c3=$((c3+1)) 
        done 
#        fi
