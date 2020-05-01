/*
	Function: fdw_demographic_pv1
	
	This function returns a table which represents the usefull data of adt_pv1 segment for a specific record from granulainbound demographic_hl7 table.

	Parameters:
		_cid - control id of the record

	Returns:
		SQL Table

	See also:
		<demographic_hl7>, <company>
*/
CREATE FUNCTION fdw_demographic_pv1(_cid VARCHAR)
RETURNS TABLE (pv1_7_1 integer, pv1_7_2 character varying, pv1_7_8 integer, pv1_8_1 integer, pv1_8_2 character varying,  pv1_8_8 integer, pv1_9_1 integer, pv1_9_2 character varying, 
pv1_9_8 integer, pv1_17_1 integer, pv1_17_2 character varying, pv1_17_8 integer, pv1_19_1 bigint, control_id character varying, company_id integer) AS $BODY$

BEGIN

RETURN QUERY EXECUTE
$$WITH x AS (SELECT control_id, hl7_msg AS hm FROM demographic_hl7 WHERE control_id = $1)
 SELECT CAST((xpath('/HL7Message/PV1/PV1.7/PV1.7.1/text()', hm))[1] AS TEXT)::INTEGER,
    CAST((xpath('/HL7Message/PV1/PV1.7/PV1.7.2/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.7/PV1.7.8/text()', hm))[1] AS TEXT)::INTEGER,
    CAST((xpath('/HL7Message/PV1/PV1.8/PV1.8.1/text()', hm))[1] AS TEXT)::INTEGER,
    CAST((xpath('/HL7Message/PV1/PV1.8/PV1.8.2/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.8/PV1.8.8/text()', hm))[1] AS TEXT)::INTEGER,
    CAST((xpath('/HL7Message/PV1/PV1.9/PV1.9.1/text()', hm))[1] AS TEXT)::INTEGER,
    CAST((xpath('/HL7Message/PV1/PV1.9/PV1.9.2/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.9/PV1.9.8/text()', hm))[1] AS TEXT)::INTEGER,
    CAST((xpath('/HL7Message/PV1/PV1.17/PV1.17.1/text()', hm))[1] AS TEXT)::INTEGER,
    CAST((xpath('/HL7Message/PV1/PV1.17/PV1.17.2/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.17/PV1.17.8/text()', hm))[1] AS TEXT)::INTEGER,
    CAST((xpath('/HL7Message/PV1/PV1.19/PV1.19.1/text()', hm))[1] AS TEXT)::BIGINT,
    control_id,
    (SELECT id FROM company WHERE code = CAST((xpath('/HL7Message/MSH/MSH.4/MSH.4.1/text()', hm))[1] AS VARCHAR))
 FROM x WHERE xmlexists('/HL7Message/PV1' PASSING BY REF hm)$$
USING _cid;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_demographic_pv1(VARCHAR)
  OWNER TO fluance;
