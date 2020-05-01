/*
	Function: fdw_demographic_nk1
	
	This function returns a table which represents the usefull data of adt_nk1 segment for a specific record from granulainbound demographic_hl7 table.

	Parameters:
		_cid - control id of the record

	Returns:
		SQL Table

	See also:
		<demographic_hl7>
*/
CREATE FUNCTION fdw_demographic_nk1(_cid VARCHAR)
RETURNS TABLE (nk1_2_1 character varying, nk1_2_2 character varying, nk1_2_3 character varying, nk1_2_4 character varying, nk1_2_5 character varying, nk1_3_1 character varying, nk1_4_1 character varying, nk1_4_2 character varying, nk1_4_3 character varying, nk1_4_4 character varying, nk1_4_5 character varying, nk1_4_6 character varying,
nk1_4_7 character varying, nk1_4_8 character varying, nk1_4_9 character varying, nk1_7_1 character varying, nk1_8_1 date, nk1_9_1 date, nk1_10_1 character varying, nk1_11_1 character varying, nk1_12_1 character varying, nk1_13_1 character varying, nk1_22_1 character varying, nk1_23_1 character varying, pid bigint, control_id character varying,
companycode character varying) AS $BODY$

BEGIN

RETURN QUERY EXECUTE
$$WITH x AS (SELECT control_id, hl7_msg AS hm FROM demographic_hl7 WHERE control_id = $1),
r AS (SELECT unnest(xpath('/HL7Message/NK1', hm)) AS hmr FROM x)
 SELECT CAST((xpath('/NK1/NK1.2/NK1.2.1/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/NK1/NK1.2/NK1.2.2/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/NK1/NK1.2/NK1.2.3/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/NK1/NK1.2/NK1.2.4/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/NK1/NK1.2/NK1.2.5/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/NK1/NK1.3/NK1.3.1/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/NK1/NK1.4/NK1.4.1/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/NK1/NK1.4/NK1.4.2/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/NK1/NK1.4/NK1.4.3/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/NK1/NK1.4/NK1.4.4/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/NK1/NK1.4/NK1.4.5/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/NK1/NK1.4/NK1.4.6/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/NK1/NK1.4/NK1.4.7/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/NK1/NK1.4/NK1.4.8/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/NK1/NK1.4/NK1.4.9/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/NK1/NK1.7/NK1.7.1/text()', hmr))[1] AS VARCHAR),
    to_date(CAST((xpath('/NK1/NK1.8/NK1.8.1/text()', hmr))[1] AS TEXT), 'YYYYMMDD'),
    to_date(CAST((xpath('/NK1/NK1.9/NK1.9.1/text()', hmr))[1] AS TEXT), 'YYYYMMDD'),
    CAST((xpath('/NK1/NK1.10/NK1.10.1/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/NK1/NK1.11/NK1.11.1/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/NK1/NK1.12/NK1.12.1/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/NK1/NK1.13/NK1.13.1/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/NK1/NK1.22/NK1.22.1/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/NK1/NK1.23/NK1.23.1/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PID/PID.3/PID.3.1/text()', hm))[1] AS TEXT)::BIGINT,
    control_id,
    CAST((xpath('/HL7Message/MSH/MSH.4/MSH.4.1/text()', hm))[1] AS VARCHAR)
 FROM r, x WHERE xmlexists('/HL7Message/NK1' PASSING BY REF hm)$$
USING _cid;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_demographic_nk1(VARCHAR)
  OWNER TO fluance;
