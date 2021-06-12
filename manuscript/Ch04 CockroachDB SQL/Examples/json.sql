USE JSON 

SELECT jsonb_pretty(jsondata) FROM customersjson WHERE customerid=1;
SELECT jsondata->'City' AS City 
  FROM customersjson WHERE customerid=1;

SELECT jsondata->'City',COUNT(*) FROM customersjson GROUP BY 1 ORDER BY 2 DESC LIMIT 10;

SELECT jsondata->>'City',COUNT(*) FROM customersjson GROUP BY 1 ORDER BY 2 DESC LIMIT 10;  //TEXT NOT json

SELECT COUNT(*) FROM customersjson 
 WHERE jsondata @> '{"City": "London"}';

SELECT COUNT(*) FROM customersjson 
 WHERE jsondata->>'City' = 'London';

SELECT jsondata->'views' FROM customersjson WHERE jsondata @> '{"City": "London"}';

SELECT jsonb_each(jsondata) FROM customersjson c2 WHERE c2.customerid =1;

SELECT jsonb_object_keys(jsondata)  FROM customersjson c2 WHERE c2.customerid =1;

SELECT jsonb_array_elements(jsondata->'views') FROM customersjson c2 WHERE c2.customerid =1;

SELECT COUNT(jsonb_array_elements(jsondata->'views')) 
  FROM customersjson 
 WHERE customerid =1;