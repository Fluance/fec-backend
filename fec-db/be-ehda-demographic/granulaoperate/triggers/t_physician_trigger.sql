-- Trigger: physician_modtime on physician

-- DROP TRIGGER physician_modtime ON physician;

CREATE TRIGGER physician_modtime
  BEFORE INSERT OR UPDATE
  ON physician
  FOR EACH ROW
  EXECUTE PROCEDURE last_modified();
