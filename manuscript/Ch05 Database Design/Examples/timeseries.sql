USE chapter05;

DROP TABLE IF EXISTS  timeseries_data ;

CREATE TABLE timeseries_data
(timestamp_pk timestamp NOT NULL PRIMARY KEY, 
 measurement float,
 metadata string);
 

INSERT INTO timeseries_data (timestamp_pk,measurement,metadata)
 WITH RECURSIVE series AS 
     ( SELECT 525600*10 AS id
        UNION ALL 
       SELECT id -1 AS id
         FROM series
        WHERE id > 0 ) 
SELECT ((date '20220101') -   (id||' minutes')::INTERVAL)::timestamp , random() randomFloat, md5(random()::STRING) randomString  FROM series;
analyze  timeseries_data;
SELECT count(*) FROM timeseries_data;

EXPLAIN SELECT avg(measurement) FROM  timeseries_data WHERE timestamp_pk > (date '20220101')- INTERVAL '1 day';

CREATE INDEX timeseries_covering ON timeseries_data(measurement_timestamp) STORING (measurement)

EXPLAIN ANALYZE SELECT AVG(measurement) FROM  timeseries_data  WHERE measurement_timestamp > ((date '20220101')- INTERVAL '500 days')