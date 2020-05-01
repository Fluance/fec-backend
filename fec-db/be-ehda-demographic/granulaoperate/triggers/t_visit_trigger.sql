-- Trigger: visit_modtime on visit

-- DROP TRIGGER visit_modtime ON visit;

CREATE TRIGGER visit_modtime
  BEFORE INSERT OR UPDATE
  ON visit
  FOR EACH ROW
  EXECUTE PROCEDURE last_modified();
