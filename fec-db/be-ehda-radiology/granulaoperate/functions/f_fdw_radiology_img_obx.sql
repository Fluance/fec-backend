/*
    Function: fdw_radiology_img_obx
        This function returns a table which represents the usefull data of OBX segments for a specific record from granulainbound radiology_hl7 table.

    Parameters:
        _cid - control id of the record

    Returns:
        SQL Table

    See also:
        <radiology_hl7>
*/
CREATE FUNCTION fdw_radiology_img_obx (_cid VARCHAR)
RETURNS TABLE (obx_3_1 character varying) AS $BODY$

BEGIN

RETURN QUERY EXECUTE
$$WITH x AS (SELECT control_id, hl7_msg AS hm FROM radiology_hl7 WHERE control_id = $1)
 SELECT CAST((xpath('/HL7Message/OBX/OBX.3/OBX.3.1/text()', hm))[1] AS VARCHAR)
 FROM x$$
USING _cid;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_radiology_img_obx(VARCHAR)
  OWNER TO fluance;
