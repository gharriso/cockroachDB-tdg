DROP TABLE tbase;
DROP TABLE target;

CREATE TABLE tbase AS SELECT * FROM adventureworks.sales.salesorderdetail s ;
 
CREATE TABLE target AS SELECT * FROM tbase WHERE 0=1;

TRUNCATE TABLE target;
EXPLAIN ANALYZE INSERT INTO target SELECT * FROM tbase;

 SELECT COUNT(*) FROM tbase;

TRUNCATE TABLE target;
CREATE INDEX base_ix1 ON target (salesorderid);
EXPLAIN ANALYZE INSERT INTO target SELECT * FROM tbase;

TRUNCATE TABLE target;
CREATE INDEX base_ix2 ON target (salesorderdetailid);
EXPLAIN ANALYZE INSERT INTO target SELECT * FROM tbase;

TRUNCATE TABLE target;
CREATE INDEX base_ix3 ON target (carriertrackingnumber);
EXPLAIN ANALYZE (DEBUG) INSERT INTO target SELECT * FROM tbase;
EXPLAIN (VERBOSE) INSERT INTO target SELECT * FROM tbase;

TRUNCATE TABLE target;
CREATE INDEX base_ix4 ON target (orderqty);
EXPLAIN ANALYZE INSERT INTO target SELECT * FROM tbase;

TRUNCATE TABLE target;
CREATE INDEX base_ix5 ON target (productid);
EXPLAIN ANALYZE INSERT INTO target SELECT * FROM tbase;

TRUNCATE TABLE target;
CREATE INDEX base_ix6 ON target (specialofferid);
EXPLAIN ANALYZE INSERT INTO target SELECT * FROM tbase;

SELECT * FROM target LIMIT 10;

EXPLAIN ANALYZE SELECT * FROM target WHERE specialofferid IS NULL