#!/bin/bash -e

#last_date=$(sqlite3 db/products.db 'select max(date) from products')

#startdate='2022-11-28'
#enddate='2022-12-02'
#
#echo "From $startdate to $enddate"
#enddate=$( date --date="$enddate" +'%Y-%m-%d' )
#thedate=$( date --date="$startdate + 1 day" +'%Y-%m-%d' )
#while [[ "$thedate" < "$enddate" ]] || [[ "$thedate" == "$enddate" ]]; do
#    echo $thedate
#    thedate=$( date --date="$thedate + 1 day" +'%Y-%m-%d' )
#done

data_dir='data'
db_dir='db'

echo -n "Accessing last date in db: "
startdate=$(sqlite3 db/products.db 'select max(date) from products')
echo $startdate
enddate=$(date +'%Y-%m-%d')

thedate=$( date --date="$startdate + 1 day" +'%Y-%m-%d' )

if [[ "$thedate" < "$enddate" ]]; then
    echo "Inserting from $thedate to $enddate"
else
    echo "Nothing to insert"
    exit 0
fi

while [[ "$thedate" < "$enddate" ]] || [[ "$thedate" == "$enddate" ]]; do
    file=$thedate-products.json
    if [[ -f $data_dir/$file ]]
    then
        cp $data_dir/$file ./temp.json
        echo "Inserting $thedate"
        sqlite3 $db_dir/products.db < ./products.sql
        if [[ $? -eq 0 ]]; then
            echo "Import successful"
        else
            echo "Error $? with Sqlite3"
            exit 1
        fi
        rm ./temp.json
        thedate=$( date --date="$thedate + 1 day" +'%Y-%m-%d' )
    else
        echo "File $data_dir/$file missing. Aborting"
        exit 1
    fi
done

exit 0