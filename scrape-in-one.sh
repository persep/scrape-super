#!/bin/bash -e

RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No Color

if [ -z "$1" ]; then
    all=true
fi

if [[ $all != "true" && $1 != "odd" && $1 != 'even' ]]; then
    echo -e "${RED}Arguments can only be odd or even${NC}"
    exit
fi

if [[ $1 == "odd" ]]; then
    odd=true
    even=false
else
    even=true
    odd=false
fi

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
    if [[ $all == true ]]; then
        echo "$n. $name ($id)"
                curl --fail --show-error --silent --compressed $url --output $file
               if (( $? != 0 )); then
              echo -e "${RED}Fail${NC}"
              exit 1
               fi
                sleep 3s
    else
        if [[ $even == true ]]; then
            if (( $n % 2 == 0)); then
                echo "$n. $name ($id)"
                curl --fail --show-error --silent --compressed $url --output $file
	           if (( $? != 0 )); then
	   	      echo -e "${RED}Fail${NC}"
	   	      exit 1
	           fi
                sleep 3s
            fi
        else 
            if (( $n % 2 != 0)); then
                echo "$n. $name ($id)"
                curl --fail --show-error --silent --compressed $url --output $file
                if (( $? != 0 )); then
                  echo -e "${RED}Fail${NC}"
                  exit 1
                fi
                sleep 3s
            fi
        fi
    fi    
    if (( $n == 5 )); then
        break
    fi
    n=$((n+1))
        
done < <(echo $categories_json | jq -c '.results[].categories[]')

echo -e "${GREEN}Success Downloading${NC}"

if [[ $all == true ]]; then
    data_dir="data"
    today=$(date +'%Y-%m-%d')

    new_file=$today-products.json
    
    echo "Joining JSONs to $data_dir/$new_file"
    jq -n -f scrape.jq $tmp_dir/*.json > $data_dir/$new_file
    
    n_products=$(jq -r "length" $data_dir/$new_file)
    
    echo "Deleting temporary folder"
    rm -r $tmp_dir
    
    echo -e "${GREEN}Finished downloading $n_products products on $today${NC}"
fi

exit 0
