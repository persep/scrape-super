#!/bin/bash -e

declare -A lookup

while read id; do
    lookup[$id]=$id
done < <(jq -r '.[].id' data-ean/products-ean.json)

today=$(date +'%Y-%m-%d')

n=1

echo "Cheking for new products ean"
while read id; do
    file="product-$id.json"
    url="https://tienda.mercadona.es/api/products/$id/?lang=es&wh=alc1"
    if [ -z lookup[$id] ]; then
        echo "$n. $id"
        curl --fail --show-error --silent --compressed $url --output "data-ean/data-raw/$file"
        ((n++))
        sleep 2s
    fi
done < <(jq -r '.[].id' data/$today-products.json)

echo "Creating new products-ean.json"
jq -n -f scrape-ean.jq data-ean/data-raw/*.json > data-ean/products-ean.json

exit 0