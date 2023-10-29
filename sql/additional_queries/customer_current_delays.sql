select c.first_name, c.last_name, r.inventory_id, r.days_left, c.phone, c.email from customers as c
inner join rental as r
on c.customer_id = r.customer_id
where r.days_left < 0 and r.`status` = "Rented";