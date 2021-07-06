
 CREATE TABLE serialtest (id serial PRIMARY KEY, x int);
INSERT INTO serialtest (x) VALUES(1);

SELECT * FROM serialtest;

DROP TABLE serialt;

CREATE TABLE serialt (id serial PRIMARY KEY , x timestamp DEFAULT current_timestamp);

INSERT INTO serialt DEFAULT values;

SELECT * FROM serialt ORDER BY x;


CREATE TABLE orders 


-- sales.salesorderheader definition

-- Drop table

-- DROP TABLE sales.salesorderheader;
--- sequense

CREATE SEQUENCE order_seq;

DROP TABLE orders;

CREATE TABLE orders  (
	orderid INT NOT NULL PRIMARY KEY DEFAULT nextval('order_seq'),
 	orderdate DATE NOT NULL DEFAULT now() ,
	duedate DATE NOT NULL,
	shipdate DATE NULL,
 	customerid INT NOT NULL,
	salespersonid INT NULL,
 	totaldue DECIMAL NULL
);

INSERT INTO orders
(duedate,  customerid, salespersonid, totaldue )
VALUES( NOW(), 1, 1, 0);
INSERT INTO orders
(duedate,  customerid, salespersonid, totaldue )
VALUES( NOW(), 1, 1, 0);
INSERT INTO orders
(duedate,  customerid, salespersonid, totaldue )
VALUES( NOW(), 1, 1, 0);
INSERT INTO orders
(duedate,  customerid, salespersonid, totaldue )
VALUES( NOW(), 1, 1, 0);

SELECT * FROM ORDERS;

--- 

DROP TABLE orders;

CREATE TABLE orders  (
	orderid uuid NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
 	orderdate DATE NOT NULL DEFAULT now() ,
	duedate DATE NOT NULL,
	shipdate DATE NULL,
 	customerid INT NOT NULL,
	salespersonid INT NULL,
 	totaldue DECIMAL NULL
);

INSERT INTO orders
(duedate,  customerid, salespersonid, totaldue )
VALUES( NOW(), 1, 1, 0);
INSERT INTO orders
(duedate,  customerid, salespersonid, totaldue )
VALUES( NOW(), 1, 1, 0);
INSERT INTO orders
(duedate,  customerid, salespersonid, totaldue )
VALUES( NOW(), 1, 1, 0);
INSERT INTO orders
(duedate,  customerid, salespersonid, totaldue )
VALUES( NOW(), 1, 1, 0);

SELECT * FROM ORDERS;


DROP TABLE orders;

CREATE TABLE orders  (
	orderid INT NOT NULL DEFAULT nextval('order_seq'),
 	orderdate DATE NOT NULL DEFAULT now() ,
	duedate DATE NOT NULL,
	shipdate DATE NULL,
 	customerid INT NOT NULL,
	salespersonid INT NULL,
 	totaldue DECIMAL NULL,
 	PRIMARY KEY  (customerid,orderid)
);

INSERT INTO orders
(duedate,  customerid, salespersonid, totaldue )
VALUES( NOW(), 1, 1, 0);
INSERT INTO orders
(duedate,  customerid, salespersonid, totaldue )
VALUES( NOW(), 1, 1, 0);
INSERT INTO orders
(duedate,  customerid, salespersonid, totaldue )
VALUES( NOW(), 1, 1, 0);
INSERT INTO orders
(duedate,  customerid, salespersonid, totaldue )
VALUES( NOW(), 1, 1, 0);

EXPLAIN SELECT * FROM ORDERS 
         WHERE ORDERID>0 
         ORDER BY ORDERID;

DROP TABLE orders;

SET experimental_enable_hash_sharded_indexes=on;

CREATE TABLE orders  (
	orderid INT NOT NULL DEFAULT nextval('order_seq'),
 	orderdate DATE NOT NULL DEFAULT now() ,
	duedate DATE NOT NULL,
	shipdate DATE NULL,
 	customerid INT NOT NULL,
	salespersonid INT NULL,
 	totaldue DECIMAL NULL ,
 	PRIMARY KEY (orderid) USING HASH WITH BUCKET_COUNT=6
);

INSERT INTO orders
(duedate,  customerid, salespersonid, totaldue )
VALUES( NOW(), 1, 1, 0);
INSERT INTO orders
(duedate,  customerid, salespersonid, totaldue )
VALUES( NOW(), 1, 1, 0);
INSERT INTO orders
(duedate,  customerid, salespersonid, totaldue )
VALUES( NOW(), 1, 1, 0);
INSERT INTO orders
(duedate,  customerid, salespersonid, totaldue )
VALUES( NOW(), 1, 1, 0);

SELECT * FROM ORDERS;
EXPLAIN SELECT * FROM ORDERS WHERE ORDERID>0 ORDER BY ORDERID;
