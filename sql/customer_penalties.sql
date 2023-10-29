select pd.customer_id, pd.first_name, pd.last_name, pl.penalties_lost, pd.penalties_delayed,
round((coalesce(pl.penalties_lost,0)+coalesce(pd.penalties_delayed,0)),2) as total_penalties from
(select  r.customer_id, c.first_name, c.last_name,
round((sum(f.replacement_cost)),2) as penalties_lost
from rental as r
inner join customers as c
on r.customer_id=c.customer_id
inner join inventory as inv
on r.inventory_id = inv.inventory_id
inner join film as f
on inv.film_id = f.film_id
where (r.`status` = "Lost") 
group by r.customer_id, c.first_name, c.last_name) as pl
right outer join
(select  r.customer_id, c.first_name, c.last_name,
round((sum(if(((r.days_left*-1)*(f.rental_rate*0.25))<0,0,((r.days_left*-1)*(f.rental_rate*0.25))))),2) as penalties_delayed 
from rental as r
inner join customers as c
on r.customer_id=c.customer_id
inner join inventory as inv
on r.inventory_id = inv.inventory_id
inner join film as f
on inv.film_id = f.film_id
where (r.days_left<1) or (r.`status` = "Lost") 
group by r.customer_id, c.first_name, c.last_name) as pd
on pl.customer_id = pd.customer_id;

