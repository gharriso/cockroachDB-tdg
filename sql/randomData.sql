USE DEFAULTdb;

DROP TABLE random_data;

CREATE TABLE random_data 
(
	id uuid NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(), 
	serial_int serial,
	int_id int,
	randomInteger int,
	randomFloat float,
	randomString string
);

INSERT INTO random_data (int_id,randomInteger,randomFloat,randomString)
with recursive series as (
	select 1 as id union all
	select id + 1 as id
   from series
   where id < 10000000)
  SELECT id int_id,(random()*10000000)::int randomInt, random() randomFloat, md5(random()::STRING) randomString FROM series;
  
 SELECT COUNT(*) FROM random_data;