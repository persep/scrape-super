#!/bin/bash -e

data_dir='data'
db_dir='db'

echo -n "Accessing last date in db: "
startdate=$(duckdb -noheader -list db/products.duck 'select max(date) from products')
echo $startdate
enddate=$(date +'%Y-%m-%d')

thedate=$( date --date="$startdate + 1 day" +'%Y-%m-%d' )

if [[ "$thedate" < "$enddate" || "$thedate" == "$enddate" ]]; then
    echo "Inserting products from $thedate to $enddate"

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

    echo "Updating ean table"
    jq -c '.[]' data-ean/products-ean.json > ./temp-ean.ndjson
    duckdb $db_dir/products.duck < ./ean.sql
    rm ./temp-ean.ndjson

else
    echo "No new products"
fi

exit 0