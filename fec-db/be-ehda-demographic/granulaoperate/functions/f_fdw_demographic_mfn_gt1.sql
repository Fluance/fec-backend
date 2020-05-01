/*
	Function: fdw_demographic_mfn_gt1
	
	This function returns a table which represents the usefull data of mfn gt1 segment for a specific record from granulainbound demographic_hl7 table.

	Parameters:
		_cid - control id of the record

	Returns:
		SQL Table

	See also:
		<demographic_hl7>
*/
CREATE FUNCTION fdw_demographic_mfn_gt1(_cid VARCHAR)
RETURNS TABLE (gt1_2_1 character varying, gt1_3_1 character varying, gt1_5_1 character varying, gt1_5_2 character varying, gt1_5_3 character varying, gt1_5_4 character varying, gt1_5_5 character varying, gt1_5_6 character varying, gt1_5_9 character varying, gt1_13_1 date, gt1_14_1 date, control_id character varying, companycode character varying) AS $BODY$

BEGIN

RETURN QUERY EXECUTE
 $$WITH x AS (SELECT control_id, hl7_msg AS hm FROM demographic_hl7 WHERE control_id = $1)
 SELECT CAST((xpath('/HL7Message/GT1/GT1.2/GT1.2.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/GT1/GT1.3/GT1.3.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/GT1/GT1.5/GT1.5.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/GT1/GT1.5/GT1.5.2/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/GT1/GT1.5/GT1.5.3/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/GT1/GT1.5/GT1.5.4/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/GT1/GT1.5/GT1.5.5/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/GT1/GT1.5/GT1.5.6/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/GT1/GT1.5/GT1.5.9/text()', hm))[1] AS VARCHAR),
    to_date(CAST((xpath('/HL7Message/GT1/GT1.13/GT1.13.1/text()', hm))[1] AS TEXT), 'YYYYMMDD'),
    to_date(CAST((xpath('/HL7Message/GT1/GT1.14/GT1.14.1/text()', hm))[1] AS TEXT), 'YYYYMMDD'),
    control_id,
    CAST((xpath('/HL7Message/MSH/MSH.4/MSH.4.1/text()', hm))[1] AS VARCHAR)
 FROM x$$
USING _cid;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_demographic_mfn_gt1(VARCHAR)
  OWNER TO fluance;
