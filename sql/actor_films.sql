select a.full_name, f.title from actor as a
inner join film_cast as fc
on a.actor_id=fc.actor_id
inner join film as f
on f.film_id = fc.film_id
where a.actor_id = 1;