DELIMITER $$
create TRIGGER ava_trig2 
AFTER update on rental 
FOR EACH ROW
BEGIN
if  !(NEW.`status` <=>OLD.`status`) then
    IF NEW.`status` = "Returned" 
    then
	UPDATE inventory
	SET availability = "Available"
    WHERE inventory_id = new.inventory_id;
    END IF; 
    end if;
END; $$
-- drop trigger ava_trig2
