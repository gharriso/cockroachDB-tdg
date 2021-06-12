USE movr;

DROP TABLE newRides;
DROP TABLE ridetestNoFK;
DROP TABLE ridetestFK;


CREATE TABLE newRides AS SELECT * FROM rides;
INSERT INTO newRides SELECT * FROM newRides;
INSERT INTO newRides SELECT * FROM newRides;
INSERT INTO newRides SELECT * FROM newRides;
INSERT INTO newRides SELECT * FROM newRides;

CREATE TABLE ridetestNoFK (
	id UUID NOT NULL,
	city VARCHAR NOT NULL,
	vehicle_city VARCHAR NULL,
	rider_id UUID NULL,
	vehicle_id UUID NULL,
	start_address VARCHAR NULL,
	end_address VARCHAR NULL,
	start_time TIMESTAMP NULL,
	end_time TIMESTAMP NULL,
	revenue DECIMAL(10,2) NULL,
	CONSTRAINT "primary" PRIMARY KEY (city ASC, id ASC)
);

CREATE TABLE ridetestFK (
	id UUID NOT NULL,
	city VARCHAR NOT NULL,
	vehicle_city VARCHAR NULL,
	rider_id UUID NULL,
	vehicle_id UUID NULL,
	start_address VARCHAR NULL,
	end_address VARCHAR NULL,
	start_time TIMESTAMP NULL,
	end_time TIMESTAMP NULL,
	revenue DECIMAL(10,2) NULL,
	CONSTRAINT "primary" PRIMARY KEY (city ASC, id ASC)
);

ALTER TABLE ridetestFK ADD CONSTRAINT ridetestFK1 FOREIGN KEY (city, rider_id) REFERENCES users(city, id);
ALTER TABLE ridetestFK ADD CONSTRAINT ridetestFK1 FOREIGN KEY (vehicle_city, vehicle_id) REFERENCES vehicles(city, id);

 

INSERT INTO ridetestFK (id,city,vehicle_city,rider_id,vehicle_id,start_address,end_address,start_time,end_time)
 SELECT gen_random_uuid(),city,vehicle_city,rider_id,vehicle_id,start_address,end_address,start_time,end_time FROM newRides;
 
 

INSERT INTO ridetestNoFK (id,city,vehicle_city,rider_id,vehicle_id,start_address,end_address,start_time,end_time)
 SELECT gen_random_uuid(),city,vehicle_city,rider_id,vehicle_id,start_address,end_address,start_time,end_time FROM newRides;
 