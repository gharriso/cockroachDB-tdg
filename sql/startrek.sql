use startrek; 

drop table episode_quote_count;

create table episode_quote_count (id integer primary key,
title text,
quote_count integer);

insert
	into
	episode_quote_count
select
	id,
	title,
	count(*) as quote_count
from
	episodes as e
left outer join quotes as q on
	(e.id = q.episode)
group by
	id,
	title;

select
	title,
	quote_count
from
	episode_quote_count
order by
	2 desc
limit 5;