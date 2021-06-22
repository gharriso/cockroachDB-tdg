DROP TABLE arrayTable;

CREATE TABLE arrayTable (arrayColumn STRING[]);
CREATE TABLE c (d INT ARRAY);

INSERT INTO arrayTable VALUES (ARRAY['sky', 'road', 'car']);
SELECT arrayColumn[2] FROM arrayTable;
 
 
SELECT * FROM arrayTable WHERE arrayColumn @>ARRAY['road'];

UPDATE  arrayTable
   SET arrayColumn=array_append(arrayColumn,'cat')
  WHERE arrayColumn @>ARRAY['car']
 RETURNING arrayColumn ;
  
 
 
UPDATE  arrayTable
   SET arrayColumn=array_remove(arrayColumn,'car')
  WHERE arrayColumn @>ARRAY['car']
  RETURNING arrayColumn;
  
 
SELECT * FROM information_schema."tables" WHERE table_schema='information_schema';

SELECT table_catalog, table_schema, table_name, table_type  
FROM information_schema."tables";

SELECT column_name,data_type, is_nullable,column_default 
 FROM information_schema.COLUMNS WHERE TABLE_NAME='customers';
 