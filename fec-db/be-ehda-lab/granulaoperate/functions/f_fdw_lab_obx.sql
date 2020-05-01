/*
	Function: fdw_lab_obx
	
	This function returns a table which represent the useful data of OBX segment from granulainbound lab_hl7 table.
	
	The following characters are unescaped in segment OBX.3.2, OBX.5.1 and OBX.7.1: '&amp;', '&lt;', and '&gt;'
	The following characters are converted in segment OBX.5.1: \.br\ --> \n (line break)

	Parameters:
		_cid - control id of the record
		_obr - ID for the parent OBR

	Returns:
		SQL TABLE

	See also:
		<lab_hl7>

*/
CREATE FUNCTION fdw_lab_obx(_cid VARCHAR, _obr INTEGER)
RETURNS TABLE (obx_1_1 integer, obx_2_1 character varying, obx_3_1 character varying, obx_3_2 character varying, obx_3_5 character varying, obx_5_1 text, obx_6_1 character varying, obx_7_1 character varying, obx_8_1 character varying, obx_11_1 character varying, parent_obr integer, control_id character varying) AS $BODY$

BEGIN

RETURN QUERY EXECUTE
$$WITH x AS (SELECT control_id, hl7_msg AS hm FROM lab_hl7 WHERE control_id = $1),
 r AS (SELECT control_id, unnest(xpath('/HL7Message/OBX', hm)) AS hmr FROM x)
 SELECT * FROM 
( SELECT CAST((xpath('/OBX/OBX.1/OBX.1.1/text()', hmr))[1] AS TEXT)::INTEGER,
	CAST((xpath('/OBX/OBX.2/OBX.2.1/text()', hmr))[1] AS VARCHAR),
	CAST((xpath('/OBX/OBX.3/OBX.3.1/text()', hmr))[1] AS VARCHAR),
	xml_unescape(CAST((xpath('/OBX/OBX.3/OBX.3.2/text()', hmr))[1] AS TEXT))::VARCHAR,
	CAST((xpath('/OBX/OBX.3/OBX.3.5/text()', hmr))[1] AS VARCHAR),
	replace(xml_unescape(CAST((xpath('/OBX/OBX.5/OBX.5.1/text()', hmr))[1] AS TEXT)), '\.br\', E'\r' ),
	CAST((xpath('/OBX/OBX.6/OBX.6.1/text()', hmr))[1] AS VARCHAR),
	xml_unescape(CAST((xpath('/OBX/OBX.7/OBX.7.1/text()', hmr))[1] AS TEXT))::VARCHAR,
	CAST((xpath('/OBX/OBX.8/OBX.8.1/text()', hmr))[1] AS VARCHAR),
	CAST((xpath('/OBX/OBX.11/OBX.11.1/text()', hmr))[1] AS VARCHAR),
	CAST((xpath('/OBX/PARENTOBR/text()', hmr))[1] AS TEXT)::INTEGER AS parent_obr,
	control_id
 FROM r) obx
 WHERE obx.parent_obr = $2$$
USING _cid, _obr;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_lab_obx(VARCHAR,INTEGER)
  OWNER TO fluance;
