DROP TABLE orderdetails;
 

CREATE TABLE orderdetails AS SELECT * FROM adventureworks.sales.salesorderdetail s;

EXPLAIN ANALYZE SELECT * FROM orderdetails ORDER BY modifieddate;

EXPLAIN ANALYZE SELECT * FROM orderdetails ORDER BY modifieddate  LIMIT 10;;

CREATE INDEX orderdetails_moddate_ix ON orderdetails(modifieddate) ;

EXPLAIN ANALYZE SELECT * FROM orderdetails ORDER BY modifieddate;

EXPLAIN ANALYZE SELECT * FROM orderdetails@orderdetails_moddate_ix ORDER BY modifieddate;

EXPLAIN ANALYZE SELECT * FROM orderdetails ORDER BY modifieddate LIMIT 10;

SELECT * 
  FROM orderdetails 
 ORDER BY modifieddate;
 
SET experimental_enable_hash_sharded_indexes=on;

CREATE INDEX orderdetails_hash_ix 
    ON orderdetails(modifieddate) 
 USING HASH WITH BUCKET_COUNT=6;

DROP INDEX orderdetails_moddate_ix;

EXPLAIN ANALYZE SELECT * FROM orderdetails@orderdetails_hash_ix  ORDER BY modifieddate LIMIT 10;
