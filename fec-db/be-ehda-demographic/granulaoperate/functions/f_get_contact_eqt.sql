/*
	Function: get_contact_eqt
		
	This function returns the hl7 description for a telecommunication equipment type
	as described here: https://www.hl7.org/fhir/v2/0202/index.html (Ex: PH = telephone).

	Parameters:
		_xtn - code

	Returns:
		hl7 db domain data VARCHAR(20)

	Algo:
		(start code)
		CASE hl7_code
			WHEN 'code' THEN return domaindata
			IF NOT FOUND THEN return 'telephone'
		END CASE
		(end code)
*/
CREATE FUNCTION get_contact_eqt(_xtn TEXT)
RETURNS VARCHAR(20) AS $$

DECLARE
	eqt VARCHAR(20);
BEGIN
	SELECT domaindata INTO eqt FROM hl7v2tables WHERE id = '0202' AND code = _xtn;
	
	IF NOT FOUND THEN
		eqt := 'telephone';
	END IF;
	
	RETURN eqt;
END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION get_contact_eqt(TEXT)
  OWNER TO fluance;
