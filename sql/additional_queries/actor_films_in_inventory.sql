select f.film_id, f.title, cat.name, inv.store_id, count(inv.film_id)  as `items available` from actor as a
inner join film_cast as fc
on a.actor_id=fc.actor_id
inner join film as f
on f.film_id = fc.film_id
inner join inventory as inv
on fc.film_id = inv.film_id
inner join category as cat
on f.category_id = cat.category_id
where a.actor_id = 34
group by f.film_id, f.title,cat.name,inv.store_id;