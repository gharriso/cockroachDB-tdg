CREATE TABLE inventory (
id INT PRIMARY KEY,
name STRING,
price FLOAT,
UNIQUE INDEX name_idx (name)
);

drop table inventory;
drop table json_inventory;

CREATE TABLE inventory(
    id INT PRIMARY KEY,
    data JSONB,
    INVERTED INDEX data_idx(data)
);

INSERT INTO inventory(id,data) values(1,'{"name":"Bat","price":1.11}');
INSERT INTO inventory(id,data) values(2,'{"name":"Ball","price":2.22}');
INSERT INTO inventory(id,data) values(3,'{"name":"Glove","price":3.33}');

select * from inventory;

DROP TABLE people;

CREATE TABLE people(
    id INT PRIMARY KEY,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    dateOfBirth DATE NOT NULL,
    mugShot  BLOB,
    FAMILY f1 (firstName,lastName,dateOfBirth),
    FAMILY f2 (mugShot)
    
);
insert into people values (1,'Fred','Codd','26-AUG-2018','^[[200~0.ub29linj5u8~0.ub29linj5u80.ub29linj5u80.ub29linj5u80.ub29linj5u8');

select * from people;

DROP TABLE people;

CREATE TABLE people(
    id INT PRIMARY KEY,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    dateOfBirth DATE NOT NULL,
    phoneNumber int not null,
    otherColumns blob ,
    INDEX (firstName,lastName,dateOfBirth) STORING (phoneNumber)
);
 

EXPLAIN SELECT phoneNumber from people where firstName='Guy' and lastName='Harrison' and dateOfBirth='1980-01-01';

