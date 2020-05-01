/*
	Function: get_contact_nbt
		
	This function returns the hl7 description for a telecommunication use code
	as described here: https://www.hl7.org/fhir/v2/0201/index.html (Ex: PRN = primary_residence_nb).

	Parameters:
		_xtn - code

	Returns:
		hl7 db domain data VARCHAR(20)

	Algo:
		(start code)
		CASE hl7_code
			WHEN 'code' THEN return domaindata
			IF NOT FOUND THEN return NULL
		END CASE
		(end code)
*/
CREATE FUNCTION get_contact_nbt(_xtn TEXT)
RETURNS VARCHAR(20) AS $$

DECLARE
	nbt VARCHAR(20);
BEGIN
	SELECT domaindata INTO nbt FROM hl7v2tables WHERE id = '0201' AND code = _xtn;
	
	IF NOT FOUND THEN
		nbt := NULL;
	END IF;
	
	RETURN nbt;
END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION get_contact_nbt(TEXT)
  OWNER TO fluance;
