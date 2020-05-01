/*
	Function: fdw_demographic_evn
	
	This function returns a table which represents the usefull data of a specific evn segment from granulainbound demographic_hl7 table.

	Parameters:
		_cid - control id of the record

	Returns:
		SQL table

	See also:
		<demographic_hl7>
*/
CREATE FUNCTION fdw_demographic_evn(_cid VARCHAR)
RETURNS TABLE (evn_1_1  character varying, evn_2_1 timestamp without time zone, evn_3_1 timestamp without time zone, evn_4_1 character varying, evn_5_1 character varying, evn_6_1 timestamp without time zone, pv1_19_1 bigint, pv1_24_1 integer, pid bigint, control_id character varying) AS $BODY$

BEGIN

RETURN QUERY EXECUTE
$$WITH x AS (SELECT control_id, hl7_msg AS hm FROM demographic_hl7 WHERE control_id = $1)
 SELECT CAST((xpath('/HL7Message/EVN/EVN.1/EVN.1.1/text()', hm))[1] AS VARCHAR) AS evn_1_1,
    to_timestamp(CAST((xpath('/HL7Message/EVN/EVN.2/EVN.2.1/text()', hm))[1] AS TEXT), 'YYYYMMDDHH24MISS')::TIMESTAMP WITHOUT TIME ZONE AS evn_2_1,
    to_timestamp(CAST((xpath('/HL7Message/EVN/EVN.3/EVN.3.1/text()', hm))[1] AS TEXT), 'YYYYMMDDHH24MISS')::TIMESTAMP WITHOUT TIME ZONE AS evn_3_1,
    CAST((xpath('/HL7Message/EVN/EVN.4/EVN.4.1/text()', hm))[1] AS VARCHAR) AS evn_4_1,
    CAST((xpath('/HL7Message/EVN/EVN.5/EVN.5.1/text()', hm))[1] AS VARCHAR) AS evn_5_1,
    to_timestamp(CAST((xpath('/HL7Message/EVN/EVN.6/EVN.6.1/text()', hm))[1] AS TEXT), 'YYYYMMDDHH24MISS')::TIMESTAMP WITHOUT TIME ZONE AS evn_6_1,
    CAST((xpath('/HL7Message/PV1/PV1.19/PV1.19.1/text()', hm))[1] AS TEXT)::BIGINT AS pv1_19_1,
    CAST((xpath('/HL7Message/PV1/PV1.24/PV1.24.1/text()', hm))[1] AS TEXT)::INTEGER AS pv1_24_1,
    CAST((xpath('/HL7Message/PID/PID.3/PID.3.1/text()', hm))[1] AS TEXT)::BIGINT,
    control_id
 FROM x$$
USING _cid;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_demographic_evn(VARCHAR)
  OWNER TO fluance;
