select
	*
from
	"order" o
join order_line ol on
	(o.o_id = ol.ol_o_id)
where
	o.o_id = 1