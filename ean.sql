CREATE TABLE IF NOT EXISTS ean(id VARCHAR UNIQUE, ean VARCHAR, brand VARCHAR, url VARCHAR, 
  name VARCHAR, description VARCHAR, category VARCHAR);

INSERT OR IGNORE into ean(id, ean, brand, url, name, description, category)
select
  json ->> '$.id',
  json ->> '$.ean',
  json ->> '$.brand',
  json ->> '$.url',
  json ->> '$.name',
  json ->> '$.description',
  json ->> '$.category'
from read_ndjson_objects('temp-ean.ndjson');
