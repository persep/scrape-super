#!/bin/bash -e

data_dir='data'
db_dir='db'

echo -n "Accessing last date in db: "
startdate=$(duckdb -noheader -list db/products.duck 'select max(date) from products')
echo $startdate
enddate=$(date +'%Y-%m-%d')

thedate=$( date --date="$startdate + 1 day" +'%Y-%m-%d' )

if [[ "$thedate" < "$enddate" || "$thedate" == "$enddate" ]]; then
    echo "Inserting from $thedate to $enddate"
else
    echo "Nothing to insert"
    exit 0
fi

while [[ "$thedate" < "$enddate" || "$thedate" == "$enddate" ]]; do
    file=$thedate-products.json
    if [[ -f $data_dir/$file ]]
    then
        jq -c '.[]' $data_dir/$file > ./temp.ndjson
        echo "Inserting $thedate"
        duckdb $db_dir/products.duck < ./products_duck.sql 
        rm ./temp.ndjson
        thedate=$( date --date="$thedate + 1 day" +'%Y-%m-%d' )
    else
        echo "File $data_dir/$file missing. Aborting"
        exit 1
    fi
done

exit 0