#!/bin/bash
#This script takes a commandline argument, essentially the xlsx file that you're working with.

#This is just to get the name of the xlsx file so we can use it for the resulting csv.
new_csv=$( basename $1 .xlsx )
csv="$new_csv.csv"

#calling the python module that converts the xlsx file to a csv. depending on your data, you might have to change the delimiter. You want one that is *not* contained in any of the fields, otherwise your data will be parsed in strange ways later on.
sudo python xlsx2csv/xlsx2csv.py -e -d $delimiter $1 $new_csv.csv

#Some variable declarations
objects='test-files'
delimiter="^"
suffix='.pdf'
c1=1

#the function to make packages
make_simple_archive_format_package () {
#looks in the directory of objects you have and iterates over them
for i in $objects/*
do
    id=$(basename $i $suffix)
    #creates each package directory
    mkdir record.$id
    #copies the objects into the package
    cp $i record.$id
    #this creates the required 'contents' files as specified in the DSpace Simple Archival Format
    echo $line > record.$id/contents
done 
}

#creates the start of the dublin core record.
make_dc_header () {
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > record.$dc_identifier/dublin_core.xml
echo "<dublin_core>" >> record.$dc_identifier/dublin_core.xml
}

#creates the closing tag
make_dc_footer () {
echo "</dublin_core>" >> record.$dc_identifier/dublin_core.xml
}

#Function to populate the dublin_core.xml needed for the upload package.
make_dc_body () {
#this is just to reset the field seperator to the default 
OLDIFS=$IFS
IFS='^'
#grabs the headers of the csv file and the second command reads it into an array.
header_row=$(head -n1 $csv)
read -a all_headers x <<< "$header_row"
#creates a temporary csv with no headers
sed 1,1d $csv > /tmp/no_headers.csv
#starts counter for cut
#calls the header function
make_dc_header
#loop to iterate over the header array
for header in "${all_headers[@]}"; do
    #setting up our variables for each xml line. The field variable searches for the identifier, grabs the associated record, and splits it into distinct fields.
    field=$(grep "$dc_identifier" $csv | cut -d"$delimiter" -f $c1)
    #these following two take the headers and use the structure to fill in the attributes for the <dcvalue> tag.
    element=$(echo "$header" | cut -d'_' -f1)
    qualifier=$(echo "$header" | cut -d'_' -f2)
    #this writes the tag. The 'printf '%b\n'' is what allows us to restore the newlines in the xml (since csv doesn't handle them gracefully.
    printf '%b\n' "<dcvalue element=\"$element\" qualifier=\"$qualifier\">$field</dcvalue>" >> record.$dc_identifier/dublin_core.xml
    c1=$((c1+1))
done
#calls the footer to close the xml record.
make_dc_footer
IFS=$OLDIFS
}

#this is for making all the records
make_dc_record () {

#loop to iterate over all the objects in the directory
for i in $objects/*
do    
    #grabs the identifier need in the make_dc_body function.
    dc_identifier=$( basename $i $suffix )
    make_dc_body
    c1=1
done
}

#for turning ampersands into character entities.
clean_ampersands () {
#iterates over all the xml records
for i in record.*/dublin_core.xml 
do
    #searches for all & and replaces with the entity code.
    sed -i 's/&/&amp;/g' $i
done
}

#call all the functions to do all the things.
#make_simple_archive_format_package
make_dc_record
clean_ampersands
