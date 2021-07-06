SELECT cast(r.start_time AS date) AS ride_date,u.city,SUM(r.revenue)
  FROM rides r
  JOIN users u ON (u.id=r.rider_id)
 GROUP BY 1,2
 
 CREATE MATERIALIZED VIEW ride_revenue_by_date_city AS 
 SELECT cast(r.start_time AS date) AS ride_date,u.city,SUM(r.revenue)
  FROM rides r
  JOIN users u ON (u.id=r.rider_id)
 GROUP BY 1,2;
 
SELECT COUNT(*) FROM ride_revenue_by_date_city
COMMIT;

 

REFRESH MATERIALIZED VIEW ride_revenue_by_date_city;