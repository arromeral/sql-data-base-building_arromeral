select r.customer_id, c.first_name, c.last_name, sum(r.days_left) as days_delayed
from rental as r
inner join customers as c
on r.customer_id=c.customer_id
where r.days_left < 0
group by  r.customer_id, c.first_name, c.last_name
order by days_delayed asc;
