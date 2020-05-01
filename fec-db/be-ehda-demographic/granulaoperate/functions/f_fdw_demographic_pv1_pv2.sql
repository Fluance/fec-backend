/*
	Function: fdw_demographic_pv1_pv2
	
	This function returns a table which represents the usefull data of adt_pv1 and adt pv2 segment for a specific record from granulainbound demographic_hl7 table.

	Parameters:
		_cid - control id of the record

	Returns:
		SQL Table

	See also:
		<demographic_hl7>, <company>
*/
CREATE FUNCTION fdw_demographic_pv1_pv2(_cid VARCHAR)
RETURNS TABLE (pv1_2_1 character varying, pv1_3_1 character varying, pv1_3_2 character varying, pv1_3_3 character varying, pv1_3_5 character varying, pv1_4_1 character varying, pv1_6_1 character varying, pv1_6_2 character varying, pv1_6_3 character varying, pv1_10_1 character varying, pv1_12_1 boolean, pv1_14_1 character varying, pv1_18_1 character varying, pv1_19_1 bigint, pv1_19_4 character varying, pv1_20_1 character varying, pv1_21_1 character varying, pv1_24_1 integer, pv1_34_1 boolean, pv1_36_1 character varying, pv1_37_1 character varying, pv1_38_1 character varying, pv1_41_1 character varying, pv1_43_1 character varying, pv1_44_1 timestamp without time zone, pv1_45_1 timestamp without time zone, pv1_47_1 numeric(9,2), pv1_50_1 smallint, pv1_51_1 character varying, pv2_3_1 character varying, pv2_6_1 character varying, pv2_8_1 timestamp without time zone, pv2_9_1 timestamp without time zone, pv2_12_1 character varying, pv2_16_1 integer, pv2_17_1 timestamp without time zone, pv2_18_1 character varying, pv2_19_1 character varying,
pv2_33_1 timestamp without time zone, pv2_41_1 character varying, pv2_41_2 character varying, pv2_41_4 character varying, pv2_41_5 character varying, pv2_41_6 character varying, admitstatus text, pid bigint, control_id character varying, companycode character varying, company_id integer) AS $BODY$

BEGIN

RETURN QUERY EXECUTE
$$WITH x AS (SELECT control_id, hl7_msg AS hm FROM demographic_hl7 WHERE control_id = $1)
 SELECT CAST((xpath('/HL7Message/PV1/PV1.2/PV1.2.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.3/PV1.3.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.3/PV1.3.2/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.3/PV1.3.3/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.3/PV1.3.5/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.4/PV1.4.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.6/PV1.6.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.6/PV1.6.2/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.6/PV1.6.3/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.10/PV1.10.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.12/PV1.12.1/text()', hm))[1] AS TEXT)::BOOLEAN,
    CAST((xpath('/HL7Message/PV1/PV1.14/PV1.14.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.18/PV1.18.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.19/PV1.19.1/text()', hm))[1] AS TEXT)::BIGINT,
    CAST((xpath('/HL7Message/PV1/PV1.19/PV1.19.4/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.20/PV1.20.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.21/PV1.21.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.24/PV1.24.1/text()', hm))[1] AS TEXT)::INTEGER,
    CAST((xpath('/HL7Message/PV1/PV1.34/PV1.34.1/text()', hm))[1] AS TEXT)::BOOLEAN,
    CAST((xpath('/HL7Message/PV1/PV1.36/PV1.36.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.37/PV1.37.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.38/PV1.38.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.41/PV1.41.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV1/PV1.43/PV1.43.1/text()', hm))[1] AS VARCHAR),
    to_timestamp(CAST((xpath('/HL7Message/PV1/PV1.44/PV1.44.1/text()', hm))[1] AS TEXT), 'YYYYMMDDHH24MISS')::TIMESTAMP WITHOUT TIME ZONE,
    to_timestamp(CAST((xpath('/HL7Message/PV1/PV1.45/PV1.45.1/text()', hm))[1] AS TEXT), 'YYYYMMDDHH24MISS')::TIMESTAMP WITHOUT TIME ZONE,
    CAST((xpath('/HL7Message/PV1/PV1.47/PV1.47.1/text()', hm))[1] AS TEXT)::NUMERIC(9,2),
    CAST((xpath('/HL7Message/PV1/PV1.50/PV1.50.1/text()', hm))[1] AS TEXT)::SMALLINT,
    CAST((xpath('/HL7Message/PV1/PV1.51/PV1.51.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV2/PV2.3/PV2.3.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV2/PV2.6/PV2.6.1/text()', hm))[1] AS VARCHAR),
    to_timestamp(CAST((xpath('/HL7Message/PV2/PV2.8/PV2.8.1/text()', hm))[1] AS TEXT), 'YYYYMMDDHH24MISS')::TIMESTAMP WITHOUT TIME ZONE,
    to_timestamp(CAST((xpath('/HL7Message/PV2/PV2.9/PV2.9.1/text()', hm))[1] AS TEXT), 'YYYYMMDDHH24MISS')::TIMESTAMP WITHOUT TIME ZONE,
    CAST((xpath('/HL7Message/PV2/PV2.12/PV2.12.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV2/PV2.16/PV2.16.1/text()', hm))[1] AS TEXT)::INTEGER,
    to_timestamp(CAST((xpath('/HL7Message/PV2/PV2.17/PV2.17.1/text()', hm))[1] AS TEXT), 'YYYYMMDDHH24MISS')::TIMESTAMP WITHOUT TIME ZONE,
    CAST((xpath('/HL7Message/PV2/PV2.18/PV2.18.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV2/PV2.19/PV2.19.1/text()', hm))[1] AS VARCHAR),
    to_timestamp(CAST((xpath('/HL7Message/PV2/PV2.33/PV2.33.1/text()', hm))[1] AS TEXT), 'YYYYMMDDHH24MISS')::TIMESTAMP WITHOUT TIME ZONE,
    CAST((xpath('/HL7Message/PV2/PV2.41/PV2.41.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV2/PV2.41/PV2.41.2/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV2/PV2.41/PV2.41.4/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV2/PV2.41/PV2.41.5/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/PV2/PV2.41/PV2.41.6/text()', hm))[1] AS VARCHAR),
    CASE CAST((xpath('/HL7Message/MSH/MSH.9/MSH.9.2/text()', hm))[1] AS VARCHAR)
	WHEN 'A01' THEN 'admitted'
	WHEN 'A04' THEN 'admitted'
	WHEN 'A05' THEN 'preadmitted'
	WHEN 'A11' THEN 'admitted'
	WHEN 'A38' THEN 'preadmitted'
	ELSE NULL
    END AS admitstatus,
    CAST((xpath('/HL7Message/PID/PID.3/PID.3.1/text()', hm))[1] AS TEXT)::BIGINT,
    control_id,
    CAST((xpath('/HL7Message/MSH/MSH.4/MSH.4.1/text()', hm))[1] AS VARCHAR),
    (SELECT id FROM company WHERE code = CAST((xpath('/HL7Message/MSH/MSH.4/MSH.4.1/text()', hm))[1] AS VARCHAR))
 FROM x$$
USING _cid;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_demographic_pv1_pv2(VARCHAR)
  OWNER TO fluance;
