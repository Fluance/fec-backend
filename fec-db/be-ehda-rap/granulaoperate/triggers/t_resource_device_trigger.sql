-- Trigger: resource_personnel_modtime on resource_personnel

-- DROP TRIGGER resource_personnel_modtime ON resource_personnel;

CREATE TRIGGER resource_device_modtime
  BEFORE INSERT OR UPDATE
  ON resource_device
  FOR EACH ROW
  EXECUTE PROCEDURE last_modified();
