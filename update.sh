#!/bin/bash -e

echo "Pulling from repo"
git pull
echo "Updating database"
bash to_db_duck.sh
