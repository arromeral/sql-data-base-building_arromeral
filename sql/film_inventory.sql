select f.film_id, f.title, inv.store_id, count(inv.film_id) as `items available` from film as f
inner join inventory as inv
on f.film_id = inv.film_id
where inv.availability = "Available" and f.film_id = 4
group by f.film_id, f.title, inv.store_id;