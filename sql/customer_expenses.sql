select r.customer_id, c.first_name, c.last_name, sum(f.rental_rate) as total_expenses from rental as r
inner join customers as c
on r.customer_id=c.customer_id
inner join inventory as inv
on r.inventory_id = inv.inventory_id
inner join film as f
on inv.film_id  = f.film_id
group by r.customer_id, c.first_name, c.last_name
order by total_expenses desc;