CREATE TABLE IF NOT EXISTS products(url VARCHAR, category VARCHAR, 
	name VARCHAR, description VARCHAR, price DOUBLE, iva INTEGER, reference_price DOUBLE, 
	reference_unit VARCHAR, date DATE, id VARCHAR);

insert into products(url, category, name, description, price, iva, reference_price, reference_unit, date, id)
select
  json ->> '$.url',
  json ->> '$.category',
  json ->> '$.name',
  json ->> '$.description',
  json ->> '$.price',
  json ->> '$.iva',
  json ->> '$.reference_price',
  json ->> '$.reference_unit',
  json ->> '$.date',
  json ->> '$.id'
from read_json_objects('temp.ndjson');