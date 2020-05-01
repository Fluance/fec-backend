-- Trigger: radiological_report_modtime on radiological_report

-- DROP TRIGGER radiological_report_modtime ON radiological_report;

CREATE TRIGGER radiological_report_modtime
  BEFORE INSERT OR UPDATE
  ON radiological_report
  FOR EACH ROW
  EXECUTE PROCEDURE last_modified();
