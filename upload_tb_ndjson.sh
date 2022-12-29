#!/bin/bash -e

data_dir="data"

today=$(date +'%Y-%m-%d')
file=$today-products.json

echo "Converting $data_dir/$file to temp.ndjson"
jq -c '.[]' $data_dir/$file > temp.ndjson

echo "Uploading products to Tb"

curl \
  -sS \
  -H "Authorization: Bearer ${TB_TOKEN}" \
  -X POST "https://api.tinybird.co/v0/datasources?format=ndjson&name=products&mode=append" \
  -F ndjson=@temp.ndjson

rm ./temp.ndjson

exit 0