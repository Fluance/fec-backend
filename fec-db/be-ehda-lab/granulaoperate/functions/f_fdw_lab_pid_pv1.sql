/*
	Function: fdw_lab_pid_pv1
	
	This function returns a table which represents the useful data of PID and PV1 segments from granulainbound lab_hl7 table.
	As multiple PID.3 segments may be provided, use the one with the PID.3.4 = 'CUSTOMER'.

	Parameters:
		_cid - control id of the record

	Returns:
		SQL TABLE

	See also:
		<lab_hl7>
*/
CREATE FUNCTION fdw_lab_pid_pv1(_cid VARCHAR)
RETURNS TABLE (pid_3_1 bigint, pv1_19_1 bigint, control_id character varying, companycode character varying) AS $BODY$

BEGIN

RETURN QUERY EXECUTE
$$WITH x AS (SELECT control_id, hl7_msg AS hm FROM lab_hl7 WHERE control_id = $1),
 p AS (SELECT unnest(xpath('/HL7Message/PID/PID.3', hm)) AS hmp FROM x)
 SELECT CAST((xpath('/PID.3/PID.3.1/text()', hmp))[1] AS TEXT)::BIGINT,
	CASE WHEN CAST((xpath('/PID.3/PID.3.1/text()', hmp))[1] AS TEXT)::BIGINT IS NULL 
	THEN CAST((xpath('/HL7Message/PV1/PV1.19/PV1.19.1/text()', hm))[1] AS TEXT)::BIGINT 
	ELSE NULL 
	END,
	control_id,
	CAST((xpath('/HL7Message/MSH/MSH.6/MSH.6.2/text()', hm))[1] AS VARCHAR)
 FROM p,x
 WHERE (xpath('/PID.3/PID.3.4/text()', hmp))[1]::TEXT = 'PARTNER'$$
USING _cid;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_lab_pid_pv1(VARCHAR)
  OWNER TO fluance;
