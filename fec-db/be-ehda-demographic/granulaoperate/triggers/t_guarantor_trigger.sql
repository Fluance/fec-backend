-- Trigger: guarantor_modtime on guarantor

-- DROP TRIGGER guarantor_modtime ON guarantor;

CREATE TRIGGER guarantor_modtime
  BEFORE INSERT OR UPDATE
  ON guarantor
  FOR EACH ROW
  EXECUTE PROCEDURE last_modified();
