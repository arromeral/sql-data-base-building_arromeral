select  f.title,a.full_name from film as f
inner join film_cast as fc
on f.film_id = fc.film_id
inner join actor as a
on a.actor_id=fc.actor_id
where f.film_id = 1;