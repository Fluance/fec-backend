-- Trigger: patient_modtime on patient

-- DROP TRIGGER patient_modtime ON patient;

CREATE TRIGGER patient_modtime
  BEFORE INSERT OR UPDATE
  ON patient
  FOR EACH ROW
  EXECUTE PROCEDURE last_modified();
