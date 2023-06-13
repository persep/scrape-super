#!/bin/bash -e

RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No Color

tmp_dir="tmp"

echo "Creating temporary folder"
mkdir $tmp_dir

url="https://tienda.mercadona.es/api/categories/?lang=es&wh=alc1"

echo -n "Downloading main categories: "
categories_json=$(curl --fail --show-error --silent --compressed $url)
if (( $? == 0 )); then
	echo -e "${GREEN}OK${NC}"
else
	echo -e "${RED}Failed downloading categories${NC}"
	exit 1
fi

n=1

while read item; do
    id=$(echo $item | jq .id)
    name=$(echo $item | jq -r .name)
    
    file=$tmp_dir/mercadona-categories-$id.json
    url="https://tienda.mercadona.es/api/categories/$id/?lang=es&wh=alc1"
    if (( $n % 2 != 0)); then
        echo "$n. $name ($id)"
        curl --fail --show-error --silent --compressed $url --output $file
	    if (( $? != 0 )); then
		    echo -e "${RED}Fail${NC}"
            # keep downloding categories even if one fails
            #exit 1
	   fi
        sleep 3s
    fi
    # for testing download only 5 categories
    #if (( $n == 5 )); then
    #    break
    #fi
    n=$((n+1))
        
done < <(echo $categories_json | jq -c '.results[].categories[]')

echo -e "${GREEN}Success Downloading${NC}"

exit 0
