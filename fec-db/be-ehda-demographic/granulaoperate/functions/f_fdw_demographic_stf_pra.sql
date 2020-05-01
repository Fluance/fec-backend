/*
	Function: fdw_demographic_stf_pra
	
	This function returns a table which represents the usefull data of mfn_stf and mfn_pra segments for a specific record from granulainbound demographic_hl7 table.

	Parameters:
		_cid - control id of the record

	Returns:
		SQL Table

	See also:
		<demographic_hl7>, <company>
*/
CREATE FUNCTION fdw_demographic_stf_pra(_cid VARCHAR)
RETURNS TABLE (stf_3_1 character varying, stf_3_2 character varying, stf_3_5 character varying, stf_11_1 character varying, stf_11_3 character varying, stf_11_4 character varying, stf_11_5 character varying, stf_11_6 character varying, stf_11_9 character varying, stf_12_1 date,
stf_13_1 date, stf_20_1 character varying, stf_27_1 character varying, sid integer, altid character varying, altidname character varying, pra_5_1 character varying, control_id character varying, companycode character varying, company_id integer) AS $BODY$

BEGIN

RETURN QUERY EXECUTE
 $$WITH x AS (SELECT control_id, hl7_msg AS hm FROM demographic_hl7 WHERE control_id = $1)
 SELECT CAST((xpath('/HL7Message/STF/STF.3/STF.3.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/STF/STF.3/STF.3.2/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/STF/STF.3/STF.3.5/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/STF/STF.11/STF.11.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/STF/STF.11/STF.11.3/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/STF/STF.11/STF.11.4/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/STF/STF.11/STF.11.5/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/STF/STF.11/STF.11.6/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/STF/STF.11/STF.11.9/text()', hm))[1] AS VARCHAR),
    to_date(CAST((xpath('/HL7Message/STF/STF.12/STF.12.1/text()', hm))[1] AS TEXT), 'YYYYMMDDHH24MISS'),
    to_date(CAST((xpath('/HL7Message/STF/STF.13/STF.13.1/text()', hm))[1] AS TEXT), 'YYYYMMDDHH24MISS'),
    CAST((xpath('/HL7Message/STF/STF.20/STF.20.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/STF/STF.27/STF.27.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/STF/STF.2/STF.2.1/text()', hm))[1] AS TEXT)::INTEGER,
    CAST((xpath('/HL7Message/STF/STF.2/STF.2.1/text()', hm))[2] AS VARCHAR),
    CAST((xpath('/HL7Message/STF/STF.2/STF.2.4/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PRA/PRA.5/PRA.5.1/text()', hm))[1] AS VARCHAR),
    control_id,
    CAST((xpath('/HL7Message/MSH/MSH.4/MSH.4.1/text()', hm))[1] AS VARCHAR),
    (SELECT id FROM company WHERE code = CAST((xpath('/HL7Message/MSH/MSH.4/MSH.4.1/text()', hm))[1] AS VARCHAR))
 FROM x$$
USING _cid;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_demographic_stf_pra(VARCHAR)
  OWNER TO fluance;
