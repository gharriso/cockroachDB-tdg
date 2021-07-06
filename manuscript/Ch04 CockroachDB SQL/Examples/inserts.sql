SELECT city, r.start_time ,revenue,           
       revenue*100/SUM(revenue) OVER () AS pct_total_revenue,
       revenue*100/SUM(revenue) OVER (PARTITION BY city) AS pct_city_revenue
  FROM rides r
 ORDER BY 5 DESC
 LIMIT 10
 
 
 SELECT city, r.start_time ,revenue,           
       RANK() OVER 
           (ORDER BY revenue DESC) AS total_revenue_rank,
       RANK() OVER 
            (PARTITION BY city ORDER BY revenue DESC) AS city_revenue_rank
  FROM rides r
 ORDER BY revenue DESC
 LIMIT 10;
 
 SELECT rank() FROM rides;

SELECT CONCAT('Hello from CockroachDB at ',
              CAST (NOW() as STRING)) as hello
              
SELECT * FROM rides

SELECT name FROM users;
SELECT u.name FROM users u;
SELECT users.name AS user_name FROM users;
SELECT u.name FROM users AS u;
 

SELECT revenue::int FROM rides

DROP TABLE people;

CREATE TABLE people ( id UUID NOT NULL DEFAULT gen_random_uuid(), firstName VARCHAR NOT NULL, lastName VARCHAR NOT NULL, dateOfBirth DATE NOT NULL );

INSERT INTO people (firstName, lastName, dateOfBirth)
VALUES ('Guy', 'Harrison', '21-JUN-1960'),
       ('Michael', 'Harrison', '19-APR-1994'),
        ('Oriana', 'Harrison', '18-JUN-2020')
  RETURNING id;
;




