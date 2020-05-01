-- Trigger: process_status_modtime on process_status

-- DROP TRIGGER process_status_modtime ON process_status;

CREATE TRIGGER process_status_modtime
  BEFORE INSERT OR UPDATE
  ON process_status
  FOR EACH ROW
  EXECUTE PROCEDURE last_modified();
