
CREATE TABLE mytable 
( 
      mycolumn int
)


CREATE TABLE public.rides (
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
	CONSTRAINT "primary" PRIMARY KEY (city ASC, id ASC),
	CONSTRAINT fk_city_ref_users 
	          FOREIGN KEY (city, rider_id) 
	          REFERENCES public.users(city, id),
	CONSTRAINT fk_vehicle_city_ref_vehicles 
	           FOREIGN KEY (vehicle_city, vehicle_id) 
	           REFERENCES public.vehicles(city, id),
	INDEX rides_auto_index_fk_city_ref_users 
	      (city ASC, rider_id ASC),
	INDEX rides_auto_index_fk_vehicle_city_ref_vehicles 
          vehicle_city ASC, vehicle_id ASC),
	CONSTRAINT check_vehicle_city_city CHECK (vehicle_city = city)
);