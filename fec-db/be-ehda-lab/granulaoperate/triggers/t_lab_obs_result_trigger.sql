-- Trigger: lab_obs_result_modtime on lab_obs_result

-- DROP TRIGGER lab_obs_result_modtime ON lab_obs_result;

CREATE TRIGGER lab_obs_result_modtime
  BEFORE INSERT OR UPDATE
  ON lab_obs_result
  FOR EACH ROW
  EXECUTE PROCEDURE last_modified();
