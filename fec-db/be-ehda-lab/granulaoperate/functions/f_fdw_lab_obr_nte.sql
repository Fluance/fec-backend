/*
	Function: fdw_lab_obr_nte
	
	This function returns a table which represents the useful data of NTE segment for a specific OBR record from granulainbound lab table.
	
	The following characters are unescaped in segment NTE.3.1: '&amp;', '&lt;', and '&gt;'
	The following characters are converted in segment NTE.3.1: \.br\ --> \n (line break)

	Parameters:
		_cid - control id of the record
		_obr - ID for the parent OBR

	Returns:
		SQL Table

	See also:
		<lab_hl7>
*/
CREATE FUNCTION fdw_lab_obr_nte(_cid VARCHAR, _obr INTEGER) RETURNS TABLE (nte_1_1 integer, nte_2_1 character varying, nte_3_1 text, parent_obr integer) AS $BODY$

BEGIN

RETURN QUERY EXECUTE
$$WITH x AS (SELECT control_id, hl7_msg AS hm FROM lab_hl7 WHERE control_id = $1),
 r AS (SELECT unnest(xpath('/HL7Message/NTE', hm)) AS hmr FROM x)
 SELECT * FROM 
( SELECT CAST((xpath('/NTE/NTE.1/NTE.1.1/text()', hmr))[1] AS TEXT)::INTEGER,
	CAST((xpath('/NTE/NTE.2/NTE.2.1/text()', hmr))[1] AS VARCHAR),
	replace(xml_unescape(CAST((xpath('/NTE/NTE.3/NTE.3.1/text()', hmr))[1] AS TEXT)), '\.br\', E'\r' ),
	CAST((xpath('/NTE/PARENTOBR/text()', hmr))[1] AS TEXT)::INTEGER AS parent_obr
 FROM r WHERE xmlexists('/NTE/PARENTOBR/node()' PASSING BY REF hmr) AND NOT xmlexists('/NTE/PARENTOBX/node()' PASSING BY REF hmr)) nte
 WHERE nte.parent_obr = $2$$
USING _cid, _obr;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_lab_obr_nte(VARCHAR,INTEGER)
  OWNER TO fluance;
