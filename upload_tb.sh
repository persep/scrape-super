#!/bin/bash -e

data_dir="data"

today=$(date +'%Y-%m-%d')
file=$today-products.json

echo "Converting $data_dir/$file to temp.csv"
jq -r '.[] | [.[]] | @csv' $data_dir/$file > temp.csv

echo "Uploading product to Tb"

curl \
  -H "Authorization: Bearer ${TB_TOKEN}" \
  -X POST "https://api.tinybird.co/v0/datasources?format=csv&name=products&mode=append" \
  -F "csv=@temp.csv"

rm ./temp.csv

exit 0