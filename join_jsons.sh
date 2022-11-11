#!/bin/bash -e

RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No Color

data_dir="data"
tmp_dir="tmp"

if [[ ! -d $data_dir ]]
then
    echo "Creating data folder"
    mkdir $data_dir
fi

today=$(date +'%Y-%m-%d')

new_file=$today-products.json

echo "Joining JSONs to $data_dir/$new_file"
jq -n -f scrape.jq $tmp_dir/*.json > $data_dir/$new_file

n_products=$(jq -r "length" $data_dir/$new_file)

echo "Deleting temporary folder"
rm -r $tmp_dir

echo -e "${GREEN}Finished downloading $n_products products on $today${NC}"

exit 0
