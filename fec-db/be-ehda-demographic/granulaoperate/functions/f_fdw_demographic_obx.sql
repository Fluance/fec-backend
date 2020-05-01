/*
	Function: fdw_demographic_obx
	
	This function returns a table which represents the usefull data of adt_obx segment for a specific record from granulainbound demographic_hl7 table.

	Parameters:
		_cid - control id of the record

	Returns:
		SQL Table

	See also:
		<demographic_hl7>
*/
CREATE FUNCTION fdw_demographic_obx(_cid VARCHAR)
RETURNS TABLE (obx_1_1 integer, obx_2_1 character varying, obx_3_2 character varying, obx_3_4 character varying,
obx_5_1 character varying, obx_6_1 character varying, obx_11_1 character varying, control_id character varying) AS $BODY$

BEGIN

RETURN QUERY EXECUTE
$$WITH x AS (SELECT control_id, hl7_msg AS hm FROM demographic_hl7 WHERE control_id = $1),
r AS (SELECT control_id, unnest(xpath('/HL7Message/OBX', hm)) AS hmr FROM x)
 SELECT CAST((xpath('/OBX/OBX.1/OBX.1.1/text()', hmr))[1] AS TEXT)::INTEGER AS obx_1_1,
    CAST((xpath('/OBX/OBX.2/OBX.2.1/text()', hmr))[1] AS VARCHAR) AS obx_2_1,
    CAST((xpath('/OBX/OBX.3/OBX.3.2/text()', hmr))[1] AS VARCHAR) AS obx_3_2,
    CAST((xpath('/OBX/OBX.3/OBX.3.4/text()', hmr))[1] AS VARCHAR) AS obx_3_4,
    CAST((xpath('/OBX/OBX.5/OBX.5.1/text()', hmr))[1] AS VARCHAR) AS obx_5_1,
    CAST((xpath('/OBX/OBX.6/OBX.6.1/text()', hmr))[1] AS VARCHAR) AS obx_6_1,
    CAST((xpath('/OBX/OBX.11/OBX.11.1/text()', hmr))[1] AS VARCHAR) AS obx_11_1,
    control_id
 FROM r WHERE xmlexists('/OBX' PASSING BY REF hmr)$$
USING _cid;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_demographic_obx(VARCHAR)
  OWNER TO fluance;
