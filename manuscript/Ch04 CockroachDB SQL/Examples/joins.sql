SELECT COUNT(*) 
  FROM vehicles v 
  JOIN rides r 
    ON (r.vehicle_id=v.id);
    
SELECT v.id,v.ext,r.start_time r.start_address 
  FROM vehicles v 
  LEFT OUTER JOIN rides r 
    ON (r.vehicle_id=v.id);
    
SELECT u.name , upc.code 
  FROM USERS u 
  JOIN user_promo_codes upc 
    ON (u.id=upc.user_id);
   
SELECT u.name , upc.code
  FROM USERS u 
  LEFT OUTER JOIN user_promo_codes upc 
    ON (u.id=upc.user_id);   
   
SELECT DISTINCT u.name , upc.code
  FROM user_promo_codes upc 
  RIGHT OUTER JOIN USERS u 
    ON (u.id=upc.user_id); 
   
 
SELECT city, user_id, code, "timestamp", usage_count
FROM public.user_promo_codes;

DROP TABLE employees;

CREATE TABLE employees AS 
 SELECT * FROM USERS LIMIT 10;

SELECT COUNT(*) FROM employees;

 SELECT *
  FROM users 
 WHERE id NOT IN 
       (SELECT id FROM employees)
       
 EXPLAIN SELECT *
   FROM users u
  WHERE NOT EXISTS 
        (SELECT id 
           FROM employees e
          WHERE e.id=u.id)
          
DROP TABLE customers;

CREATE TABLE customers AS SELECT * FROM USERS WHERE city <> 'boston';

SELECT *
   FROM users u
  WHERE NOT EXISTS 
        (SELECT id 
           FROM employees e
          WHERE e.id=u.id)
       
SELECT name, address 
  FROM customers
 MINUS 
SELECT name,address
  FROM employees;

