#!/bin/bash -e

echo "Uploading product to Tb"

#data_dir="data"
#
#today=$(date +'%Y-%m-%d')
#file=$today-products.json
#
#echo "Converting $data_dir/$file to csv"
#jq -r '.[] | [.[]] | @csv' $data_dir/$file > temp.json
#
#echo "Uploading product to Tb"
#
#
#rm ./temp.json


curl \
  -H 'Authorization: Bearer ${TB_TOKEN}' \
  -X POST 'https://api.tinybird.co/v0/datasources?format=csv&name=products&mode=append' \
  -F "csv=@temp.csv"


exit 0