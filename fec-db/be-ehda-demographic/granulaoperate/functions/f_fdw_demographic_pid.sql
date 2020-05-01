/*
	Function: fdw_demographic_pid
	
	This function returns a table which represents the usefull data of adt_pid segment for a specific record from granulainbound demographic_hl7 table.

	Parameters:
		_cid - control id of the record

	Returns:
		SQL Table

	See also:
		<demographic_hl7>
*/
CREATE FUNCTION fdw_demographic_pid(_cid VARCHAR)
RETURNS TABLE (pid_5_1 character varying, pid_5_2 character varying, pid_5_5 character varying, pid_6_1 character varying, pid_7_1 date, pid_8_1 character varying, pid_11_1 character varying, pid_11_2 character varying, pid_11_3 character varying, pid_11_4 character varying, pid_11_5 character varying, pid_11_6 character varying, pid_11_7 character varying, pid_11_8 character varying, pid_11_9 character varying, pid_15_1 character varying, pid_16_1 character varying, pid_17_1 character varying, pid_19_1 character varying, pid_20_1 character varying, pid_21_1 bigint, pid_23_1 character varying, pid_24_1 character varying, pid_25_1 boolean, pid_27_1 character varying, pid_27_2 character varying, pid_27_3 character varying, pid_27_4 character varying, pid_28_1 character varying, pid_29_1 timestamp without time zone, pid_30_1 boolean, pid_31_1 character varying, pid bigint, refnb character varying, mn character varying, fn character varying, sn character varying, control_id character varying, companycode character varying) AS $BODY$

BEGIN

RETURN QUERY EXECUTE
$$WITH x AS (SELECT control_id, hl7_msg AS hm FROM demographic_hl7 WHERE control_id = $1)
 SELECT CAST((xpath('/HL7Message/PID/PID.5/PID.5.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.5/PID.5.2/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.5/PID.5.5/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.6/PID.6.1/text()', hm))[1] AS VARCHAR),
    to_date(CAST((xpath('/HL7Message/PID/PID.7/PID.7.1/text()', hm))[1] AS TEXT), 'YYYYMMDDHH24MISS'),
    CAST((xpath('/HL7Message/PID/PID.8/PID.8.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.11/PID.11.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.11/PID.11.2/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.11/PID.11.3/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.11/PID.11.4/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.11/PID.11.5/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.11/PID.11.6/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.11/PID.11.7/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.11/PID.11.8/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.11/PID.11.9/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.15/PID.15.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.16/PID.16.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.17/PID.17.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.19/PID.19.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.20/PID.20.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.21/PID.21.1/text()', hm))[1] AS TEXT)::BIGINT,
    CAST((xpath('/HL7Message/PID/PID.23/PID.23.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.24/PID.24.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.25/PID.25.1/text()', hm))[1] AS TEXT)::BOOLEAN,
    CAST((xpath('/HL7Message/PID/PID.27/PID.27.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.27/PID.27.2/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.27/PID.27.3/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.27/PID.27.4/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.28/PID.28.1/text()', hm))[1] AS VARCHAR),
    to_timestamp(CAST((xpath('/HL7Message/PID/PID.29/PID.29.1/text()', hm))[1] AS TEXT), 'YYYYMMDDHH24MISS')::TIMESTAMP WITHOUT TIME ZONE,
    CAST((xpath('/HL7Message/PID/PID.30/PID.30.1/text()', hm))[1] AS TEXT)::BOOLEAN,
    CAST((xpath('/HL7Message/PID/PID.31/PID.31.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.3/PID.3.1/text()', hm))[1] AS TEXT)::BIGINT,
    CAST((xpath('/HL7Message/PID/PID.3/PID.3.1/text()', hm))[2] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.22/PID.22.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.22/PID.22.2/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.22/PID.22.3/text()', hm))[1] AS VARCHAR),
    control_id,
    CAST((xpath('/HL7Message/MSH/MSH.4/MSH.4.1/text()', hm))[1] AS VARCHAR)
 FROM x$$
USING _cid;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_demographic_pid(VARCHAR)
  OWNER TO fluance;
