-- Trigger: lab_obs_request_modtime on lab_obs_request

-- DROP TRIGGER lab_obs_request_modtime ON lab_obs_request;

CREATE TRIGGER lab_obs_request_modtime
  BEFORE INSERT OR UPDATE
  ON lab_obs_request
  FOR EACH ROW
  EXECUTE PROCEDURE last_modified();
