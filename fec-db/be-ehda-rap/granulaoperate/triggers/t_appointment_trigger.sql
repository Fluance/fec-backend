-- Trigger: appointment_modtime on appointment

-- DROP TRIGGER appointment_modtime ON appointment;

CREATE TRIGGER appointment_modtime
  BEFORE INSERT OR UPDATE
  ON appointment
  FOR EACH ROW
  EXECUTE PROCEDURE last_modified();
