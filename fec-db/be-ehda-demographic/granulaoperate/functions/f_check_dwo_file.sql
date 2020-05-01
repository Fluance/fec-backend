/*
	Function: check_dwo_file
	
	This function's goal is to verify that a file with the same batch number has not already been processed

	Parameters:
		_bnb - current batch number
		_comp - company code

	Returns:
		False if the company does not exist or the file has already been processed, true otherwise

	Algo:
		(start code)
		IF !(_comp) THEN
			RETURN FALSE
		ENDIF
		IF (_bnb) THEN
			RETURN FALSE
		ENDIF
		
		RETURN TRUE
		(end code)

	See also:	
		<demographic_dwo_invoice>
*/

CREATE FUNCTION check_dwo_file (_bnb BIGINT, _comp VARCHAR(50))
RETURNS BOOLEAN AS $$

DECLARE

BEGIN

    -- Check if company code exists
    IF NOT EXISTS (SELECT 1 FROM company c WHERE c.code = _comp) THEN
	RETURN FALSE;
    END IF;
    
    -- Check if file already processed
    IF EXISTS (SELECT 1 FROM demographic_dwo_invoice o WHERE o.batchnb = _bnb) THEN
	RETURN FALSE;
    END IF;
    
    RETURN TRUE;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION check_dwo_file (BIGINT, VARCHAR)
OWNER TO fluance;
