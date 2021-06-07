UPDATE users 
  SET address = '201 E Randolph St',
  	  city='amsterdam'
 WHERE name='Maria Weber'

 
 UPDATE rides SET (revenue, start_address) =
    (SELECT revenue, end_address FROM rides 
      WHERE id = '94fdf3b6-45a1-4800-8000-000000000123')
 WHERE id = '851eb851-eb85-4000-8000-000000000104';

 SELECT * FROM user_promo_codes;

UPDATE user_promo_codes 
   SET usage_count=usage_count+1
  WHERE user_id='297fcb80-b67a-4c8b-bf9f-72c404f97fe8'
 RETURNING (usage_count)

 
SELECT id FROM "users" u WHERE id NOT IN (SELECT user_id FROM user_promo_codes)
  
SELECT * FROM USERS;

UPSERT INTO user_promo_codes 
  (user_id,city,code,timestamp,usage_count)
SELECT id,city,'NewPromo',now(),0
  FROM "users" 
  
DELETE FROM user_promo_codes
 WHERE code='NewPromo'
RETURNING(user_id);
 
