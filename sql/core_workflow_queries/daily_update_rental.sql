update rental as r
set r.return_date = now()
where r.`status` = "Rented";