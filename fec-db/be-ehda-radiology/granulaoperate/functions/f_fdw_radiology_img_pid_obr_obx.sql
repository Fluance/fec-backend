/*
    Function: fdw_radiology_img_pid_obr_obx
        This function returns a table which represents the usefull data of PID, OBR and OBX segments for a specific record from granulainbound radiology_hl7 table.

    Parameters:
        _cid - control id of the record

    Returns:
        SQL Table

    See also:
        <radiology_hl7>
*/
CREATE FUNCTION fdw_radiology_img_pid_obr_obx (_cid VARCHAR)
RETURNS TABLE (pid_3_1 bigint, obr_3_1 character varying, obr_20_1 character varying, obr_21_1 character varying, obr_24_1 character varying, obx_3_1 character varying, obx_5_2 character varying, obx_14_1 timestamp without time zone, control_id character varying, company_id integer) AS $BODY$

BEGIN

RETURN QUERY EXECUTE
$$WITH x AS (SELECT control_id, hl7_msg AS hm FROM radiology_hl7 WHERE control_id = $1)
 SELECT CAST((xpath('/HL7Message/PID/PID.3/PID.3.1/text()', hm))[1] AS TEXT)::BIGINT,
    CAST((xpath('/HL7Message/OBR/OBR.3/OBR.3.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/OBR/OBR.20/OBR.20.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/OBR/OBR.21/OBR.21.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/OBR/OBR.24/OBR.24.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/OBX/OBX.3/OBX.3.1/text()', hm))[1] AS VARCHAR),
    CAST((xpath('/HL7Message/OBX/OBX.5/OBX.5.2/text()', hm))[1] AS VARCHAR),
    to_timestamp(CAST((xpath('/HL7Message/OBX/OBX.14/OBX.14.1/text()', hm))[1] AS TEXT), 'YYYYMMDDHH24MISS')::TIMESTAMP WITHOUT TIME ZONE,
    control_id,
    (SELECT id FROM company WHERE code = CAST((xpath('/HL7Message/MSH/MSH.4/MSH.4.1/text()', hm))[1] AS VARCHAR))
 FROM x$$
USING _cid;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_radiology_img_pid_obr_obx(VARCHAR)
  OWNER TO fluance;
