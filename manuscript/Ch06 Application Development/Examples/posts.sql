CREATE DATABASE chapter06;

USE chapter06;

DROP TABLE IF EXISTS  blog_posts ;

CREATE TABLE blog_posts
(id uuid NOT NULL PRIMARY KEY default gen_random_uuid(),
 post_timestamp timestamp NOT NULL ,
 userid int,
 summary string);
 

INSERT INTO blog_posts ( post_timestamp,userid,summary)
 WITH RECURSIVE series AS 
     ( SELECT 525600*10 AS id
        UNION ALL 
       SELECT id -1 AS id
         FROM series
        WHERE id > 0 ) 
SELECT ((date '20220101') -   (id||' minutes')::INTERVAL)::timestamp , ROUND(random()*1000)::int , 
md5(random()::STRING)||md5(random()::STRING)||md5(random()::STRING)||md5(random()::STRING)||md5(random()::STRING)||md5(random()::STRING)||md5(random()::STRING)||md5(random()::STRING)||md5(random()::STRING)||md5(random()::STRING)||md5(random()::STRING) randomString  FROM series;


CREATE INDEX timeseries_covering ON blog_posts(post_timestamp) STORING (summary);

analyze  blog_posts;

EXPLAIN  SELECT post_timestamp, summary FROM blog_posts ORDER BY post_timestamp DESC 