update rental as r
inner join inventory as inv
on r.inventory_id = inv.inventory_id
inner join film as f
on inv.film_id = f.film_id
set r.rental_duration = f.rental_duration, 
r.days_left = r.rental_duration - (TIMESTAMPDIFF(day,r.rental_date, r.return_date))
;
