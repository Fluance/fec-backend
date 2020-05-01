/*
	Function: fdw_lab_obr
	
	This function returns a table which represent the useful data of OBR segment from granulainbound lab_hl7 table.

	Parameters:
		_cid - control id of the record

	Returns:
		SQL TABLE

	See also:
		<lab_hl7>
*/
CREATE FUNCTION fdw_lab_obr(_cid VARCHAR)
RETURNS TABLE (obr_1_1 integer, obr_3_1 character varying, obr_3_2 character varying, obr_4_1 character varying, obr_4_2 character varying, obr_7_1 timestamp without time zone, control_id character varying) AS $BODY$

BEGIN

RETURN QUERY EXECUTE
$$WITH x AS (SELECT control_id, hl7_msg AS hm FROM lab_hl7 WHERE control_id = $1),
 r AS (SELECT unnest(xpath('/HL7Message/OBR', hm)) AS hmr FROM x)
 SELECT CAST((xpath('/OBR/OBR.1/OBR.1.1/text()', hmr))[1] AS TEXT)::INTEGER,
	CAST((xpath('/OBR/OBR.3/OBR.3.1/text()', hmr))[1] AS VARCHAR),
	CAST((xpath('/OBR/OBR.3/OBR.3.2/text()', hmr))[1] AS VARCHAR),
	CAST((xpath('/OBR/OBR.4/OBR.4.1/text()', hmr))[1] AS VARCHAR),
	CAST((xpath('/OBR/OBR.4/OBR.4.2/text()', hmr))[1] AS VARCHAR),
	to_timestamp(CAST((xpath('/OBR/OBR.7/OBR.7.1/text()', hmr))[1] AS TEXT), 'YYYYMMDDHH24MISS')::TIMESTAMP WITHOUT TIME ZONE,
	control_id
 FROM r,x$$
USING _cid;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_lab_obr(VARCHAR)
  OWNER TO fluance;
