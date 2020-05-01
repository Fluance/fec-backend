-- Trigger: radiological_serie_modtime on radiological_serie

-- DROP TRIGGER radiological_serie_modtime ON radiological_serie;

CREATE TRIGGER radiological_serie_modtime
  BEFORE INSERT OR UPDATE
  ON radiological_serie
  FOR EACH ROW
  EXECUTE PROCEDURE last_modified();
