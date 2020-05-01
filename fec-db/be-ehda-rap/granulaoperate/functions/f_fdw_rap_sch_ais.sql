/*
    Function: fdw_rap_sch_ais
        This function returns a table which represents the usefull data of sch and ais segments for a specific record from granulainbound rap_hl7 table.

    Parameters:

        _cid - control id of the record

    Returns:
        SQL Table

    See also:
        <rap_hl7>
*/
CREATE FUNCTION fdw_rap_sch_ais(_cid VARCHAR)
RETURNS TABLE (pv1_19_1 bigint, sch_2_1 bigint, sch_4_1 bigint, sch_5_1 integer, sch_5_2 text, sch_11_3 integer, sch_11_4 timestamp without time zone, sch_11_5 timestamp without time zone,  
ais_2_1 text, ais_2_2 text, ais_2_4 text, ais_2_8 character varying, ais_10_1 character varying, ais_12_1 integer, control_id character varying, company_id integer) AS $BODY$

BEGIN

RETURN QUERY EXECUTE
$$WITH x AS (SELECT control_id, hl7_msg AS hm FROM rap_hl7 WHERE control_id = $1)
 SELECT
    CAST((xpath('/HL7Message/PV1/PV1.19/PV1.19.1/text()', hm))[1] AS TEXT)::BIGINT,
    CAST((xpath('/HL7Message/SCH/SCH.2/SCH.2.1/text()', hm))[1] AS TEXT)::BIGINT,
    CAST((xpath('/HL7Message/SCH/SCH.4/SCH.4.1/text()', hm))[1] AS TEXT)::BIGINT,
    CAST((xpath('/HL7Message/SCH/SCH.5/SCH.5.1/text()', hm))[1] AS TEXT)::INTEGER,
    CAST((xpath('/HL7Message/SCH/SCH.5/SCH.5.2/text()', hm))[1] AS TEXT),
    CAST((xpath('/HL7Message/SCH/SCH.11/SCH.11.3/text()', hm))[1] AS TEXT)::INTEGER,
    to_timestamp(CAST((xpath('/HL7Message/SCH/SCH.11/SCH.11.4/text()', hm))[1] AS TEXT), 'YYYYMMDDHH24MISS')::TIMESTAMP WITHOUT TIME ZONE,
    to_timestamp(CAST((xpath('/HL7Message/SCH/SCH.11/SCH.11.5/text()', hm))[1] AS TEXT), 'YYYYMMDDHH24MISS')::TIMESTAMP WITHOUT TIME ZONE,
    CAST((xpath('/HL7Message/AIS/AIS.2/AIS.2.1/text()', hm))[1] AS TEXT),
    CAST((xpath('/HL7Message/AIS/AIS.2/AIS.2.2/text()', hm))[1] AS TEXT),
    CAST((xpath('/HL7Message/AIS/AIS.2/AIS.2.4/text()', hm))[1] AS TEXT),
    CAST((xpath('/HL7Message/AIS/AIS.2/AIS.2.8/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/AIS/AIS.10/AIS.10.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/AIS/AIS.12/AIS.12.1/text()', hm))[1] AS TEXT)::INTEGER,
    control_id,
    (SELECT id FROM company WHERE code = CAST((xpath('/HL7Message/MSH/MSH.4/MSH.4.1/text()', hm))[1] AS VARCHAR))
 FROM x$$
USING _cid;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_rap_sch_ais(VARCHAR)
  OWNER TO fluance;
