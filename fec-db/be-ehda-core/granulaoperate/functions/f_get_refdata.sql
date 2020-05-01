/*
	Function: get_refdata
		
	This function helps to retreive a description from refdata table.

	Parameters:
		_srctable - name of the source table (Ex: TBS.OPA.TYPEADM)
		_company - company code
		_code - code
		_table - materialized view.

	Returns:
		Description of the code.

	See also:
		<company>, <refdata>

*/
CREATE FUNCTION get_refdata(_srctable VARCHAR(50), _company VARCHAR(4), _code VARCHAR(50), _table VARCHAR(50))
RETURNS VARCHAR AS $$

DECLARE
	v_cid INTEGER;
	v_res VARCHAR(255);

BEGIN
	-- Get company ID
	SELECT id INTO v_cid FROM company WHERE code = _company;

	-- Get codedesc from table
	EXECUTE format('SELECT codedesc FROM %I WHERE srctable = %L AND company_id = %L AND code = %L', _table, _srctable, v_cid, _code) INTO v_res;

	RETURN v_res;
END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION get_refdata(VARCHAR, VARCHAR, VARCHAR, VARCHAR)
  OWNER TO fluance;
