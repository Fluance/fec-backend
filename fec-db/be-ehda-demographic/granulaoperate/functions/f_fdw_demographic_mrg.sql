/*
	Function: fdw_demographic_mrg
	
	This function returns a table which represents the usefull data of adt_mrg segment for a specific record from granulainbound demographic_hl7 table.

	Parameters:
		_cid - control id of the record

	Returns:
		SQL Table

	See also:
		<demographic_hl7>
*/
CREATE FUNCTION fdw_demographic_mrg(_cid VARCHAR)
RETURNS TABLE (mrg_1_1 integer, mrg_5_1 integer, mrg_6_1 smallint, control_id character varying) AS $BODY$

BEGIN

RETURN QUERY EXECUTE
$$WITH x AS (SELECT control_id, hl7_msg AS hm FROM demographic_hl7 WHERE control_id = $1)
 SELECT CAST((xpath('/HL7Message/MRG/MRG.1/MRG.1.1/text()', hm))[1] AS TEXT)::INTEGER AS mrg_1_1,
    CAST((xpath('/HL7Message/MRG/MRG.5/MRG.5.1/text()', hm))[1] AS TEXT)::INTEGER AS mrg_5_1,
    CAST((xpath('/HL7Message/MRG/MRG.6/MRG.6.1/text()', hm))[1] AS TEXT)::SMALLINT AS mrg_6_1,
    control_id
 FROM x$$
USING _cid;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_demographic_mrg(VARCHAR)
  OWNER TO fluance;
