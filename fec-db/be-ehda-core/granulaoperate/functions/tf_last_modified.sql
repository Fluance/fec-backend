/*
	Function: last_modified
	
	This function returns a timestamp used to identify when a record has been modified
	
	Parameters:
		None
	
	Returns:
		now() Current date and time (start of current transaction)

*/
CREATE OR REPLACE FUNCTION last_modified()
  RETURNS trigger AS
	$BODY$
	BEGIN
		NEW.lastmodified = now(); 
		RETURN NEW;
	END;
	$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

ALTER FUNCTION last_modified()
  OWNER TO fluance;
