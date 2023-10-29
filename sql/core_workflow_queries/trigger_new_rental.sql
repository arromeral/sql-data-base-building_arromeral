CREATE TRIGGER ava_trig AFTER INSERT ON rental 
FOR EACH ROW
  UPDATE inventory
     SET availability = "Not available"
   WHERE inventory_id = NEW.inventory_id;
   
