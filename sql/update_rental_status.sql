UPDATE rental
SET return_date = CURRENT_TIMESTAMP, `status` = "Returned", last_update = CURRENT_TIMESTAMP
WHERE rental_id = 15;