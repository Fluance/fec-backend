-- Trigger: invoice_modtime on invoice

-- DROP TRIGGER invoice_modtime ON invoice;

CREATE TRIGGER invoice_modtime
  BEFORE INSERT OR UPDATE
  ON invoice
  FOR EACH ROW
  EXECUTE PROCEDURE last_modified();
