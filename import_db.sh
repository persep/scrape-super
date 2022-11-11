#!/bin/bash -e

echo "Importing products to Sqlite"

echo "Downloading sqlite3"
sudo curl https://github.com/nalgeon/sqlite/releases/download/3.39.3/sqlite3-ubuntu -4 -sL -o /usr/bin/sqlite3
sudo chmod +x /usr/bin/sqlite3
sqlite_version=$(sqlite3 --version | cut -d " " -f 1)
echo "sqlite3 $sqlite_version installed"

data_dir="data"

today=$(date +'%Y-%m-%d')
file=$today-products.json
echo "$data_dir/$file to ./temp.json"
cp $data_dir/$file ./temp.json

echo "Importing products json"
sqlite3 data/products.db < ./products.sql
if [[ $? -eq 0 ]]; then
	echo "Import successful"
else
	echo "Error $? with Sqlite3"
	exit 1
fi
echo "Deleting ./temp.json"
rm ./temp.json
exit 0