/*
	Function: fdw_demographic_dwo_inv
	
	This function returns a table which represent the usefull invoices data from granulainbound demographic_dwo_invoice table.

	Parameters:
		_cid - uuid of the record

	Returns:
		SQL TABLE

	See also:
		<demographic_dwo_invoice>
*/
CREATE FUNCTION fdw_demographic_dwo_inv(_cid UUID)
RETURNS TABLE (pid bigint, nb bigint, invid bigint, sequencenb integer, reversalnb bigint, invdt timestamp without time zone, total numeric, balance numeric, apdrg_code character varying, apdrg_descr character varying, mdc_code character varying,
 mdc_descr character varying, control_id uuid, guarantor_code character varying, priority integer, subpriority integer, companycode character varying, batchnb bigint) AS $BODY$

BEGIN
RETURN QUERY EXECUTE
$$ SELECT
    (dwo_msg#>>'{DWOmessage, 1}')::BIGINT AS pid,
    (dwo_msg#>>'{DWOmessage, 64}')::BIGINT AS nb,
    (dwo_msg#>>'{DWOmessage, 3}')::BIGINT AS invid,
    (dwo_msg#>>'{DWOmessage, 4}')::INTEGER AS sequencenb,
    (dwo_msg#>>'{DWOmessage, 13}')::BIGINT AS reversalnb,
    (dwo_msg#>>'{DWOmessage, 7}')::TIMESTAMP WITHOUT TIME ZONE AS invdt,
    (dwo_msg#>>'{DWOmessage, 12}')::NUMERIC AS total,
    (dwo_msg#>>'{DWOmessage, 16}')::NUMERIC AS balance,
    (dwo_msg#>>'{DWOmessage, 35}')::VARCHAR AS apdrg_code,
    (dwo_msg#>>'{DWOmessage, 36}')::VARCHAR AS apdrg_descr,
    (dwo_msg#>>'{DWOmessage, 39}')::VARCHAR AS mdc_code,
    (dwo_msg#>>'{DWOmessage, 40}')::VARCHAR AS mdc_descr,
    control_id,
    (dwo_msg#>>'{DWOmessage, 5}')::VARCHAR AS guarantor_code,
    (dwo_msg#>>'{DWOmessage, 54}')::INTEGER AS priority,
    (dwo_msg#>>'{DWOmessage, 55}')::INTEGER AS subpriority,
    (dwo_msg#>>'{DWOmessage, 0}')::VARCHAR AS companycode,
    (dwo_msg#>>'{DWOmessage, 63}')::BIGINT AS batchnb
    FROM demographic_dwo_invoice WHERE control_id = $1
$$
USING _cid;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_demographic_dwo_inv(UUID)
  OWNER TO fluance;
