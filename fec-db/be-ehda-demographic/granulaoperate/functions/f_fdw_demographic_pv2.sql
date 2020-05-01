/*
	Function: fdw_demographic_pv2
	
	This function returns a table which represents the usefull data of ADT PV2 segment for a specific record from granulainbound demographic_hl7 table.
	The main use is for retrieving the treatment and diagnosis data, for both visit and intervention

	Parameters:
		_cid - control id of the record

	Returns:
		SQL Table

	See also:
		<demographic_hl7>
*/
CREATE FUNCTION fdw_demographic_pv2(_cid VARCHAR)
RETURNS TABLE (data character varying, type character varying, scope character varying, pos bigint, control_id character varying) AS $BODY$

BEGIN

RETURN QUERY EXECUTE
$$WITH x AS (SELECT control_id, hl7_msg AS hm FROM demographic_hl7 WHERE control_id = $1),
r1 AS (SELECT control_id,unnest(xpath('/HL7Message/PV2/PV2.39', hm)) AS hmr1 FROM x),
r2 AS (SELECT control_id,unnest(xpath('/HL7Message/PV2/PV2.40', hm)) AS hmr2 FROM x),
r3 AS (SELECT control_id,unnest(xpath('/HL7Message/PV2/PV2.42',hm)) AS hmr3 FROM x),
r4 AS (SELECT control_id,unnest(xpath('/HL7Message/PV2/PV2.45',hm)) AS hmr4 FROM x)
 SELECT CAST((xpath('/PV2.39/PV2.39.1/text()', hmr1))[1] AS VARCHAR),
    'treatment'::VARCHAR AS type,
    'visit'::VARCHAR AS scope,
    row_number() OVER () AS pos,
    control_id
 FROM r1 WHERE xmlexists('/PV2.39/node()' PASSING BY REF hmr1)
 UNION ALL
 SELECT CAST((xpath('/PV2.40/PV2.40.1/text()', hmr2))[1] AS VARCHAR),
    'diagnosis'::VARCHAR AS type,
    'visit'::VARCHAR AS scope,
    row_number() OVER () AS pos,
    control_id
 FROM r2 WHERE xmlexists('/PV2.40/node()' PASSING BY REF hmr2)
 UNION ALL
 SELECT elem,
    'diagnosis'::VARCHAR AS type,
    'intervention'::VARCHAR AS scope,
    pos,
    control_id
 FROM r3, unnest(string_to_array(CAST((xpath('/PV2.42/PV2.42.2/text()', hmr3))[1] AS TEXT),';')) WITH ORDINALITY t(elem, pos) WHERE xmlexists('/PV2.42/node()' PASSING BY REF hmr3)
 UNION ALL
 SELECT elem,
    'operation'::VARCHAR AS type,
    'intervention'::VARCHAR AS scope,
    pos,
    control_id
 FROM r4, unnest(string_to_array(CAST((xpath('/PV2.45/PV2.45.2/text()', hmr4))[1] AS TEXT),';')) WITH ORDINALITY t(elem, pos) WHERE xmlexists('/PV2.45/node()' PASSING BY REF hmr4)
 ORDER BY scope, type, pos$$
USING _cid;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_demographic_pv2(VARCHAR)
  OWNER TO fluance;
