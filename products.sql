CREATE TABLE IF NOT EXISTS "products"(
"url" TEXT, "category" TEXT, "name" TEXT, "description" TEXT,
 "price" TEXT, "reference_price" TEXT, "reference_unit" TEXT, "date" TEXT,
 "id" TEXT);

insert into products(url, category, name, description, price, reference_price, reference_unit, date, id)
select
  value ->> '$.url',
  value ->> '$.category',
  value ->> '$.name',
  value ->> '$.description',
  value ->> '$.price',
  value ->> '$.reference_price',
  value ->> '$.reference_unit',
  value ->> '$.date',
  value ->> '$.id'
from json_each(readfile('temp.json'));

