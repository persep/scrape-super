#!/bin/bash -e

today=$(date +'%Y-%m-%d')

n=1

while read id; do
    file="product-$id.json"
    url="https://tienda.mercadona.es/api/products/$id/?lang=es&wh=alc1"
    if [ ! -f "data-ean/$file" ]; then
        echo "$n. $id"
        curl --fail --show-error --silent $url --output "data-ean/$file"
        ((n++))
        sleep 2s
    fi
done < <(jq -r '.[].id' data/$today-products.json)

exit 0
