select * from public.customer 
join "order" o on (o_c_id=c_id)
join order_line ol on (ol_o_id=o_id)
where c_id=1 limit  1

select * from customer where c_id=1 and c_d_id=1 and c_w_id=0;

select * from customer where c_first='9cdLXe0Yhg'