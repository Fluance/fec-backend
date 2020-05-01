/*

    Function: fdw_rap_nte
        This function returns a table which represents the usefull data of nte segment for a specific record from granulainbound rap_hl7 table.



    Parameters:

        _cid - control id of the record



    Returns:
        SQL Table



    See also:
        <rap_hl7>

*/
CREATE FUNCTION fdw_rap_nte(_cid VARCHAR) RETURNS TABLE (nte_1_1 integer, nte_3_1 timestamp without time zone, nte_4_1 integer, nte_4_2 text, nte_4_4 character varying, control_id character varying, company_id integer) AS $BODY$

BEGIN

RETURN QUERY EXECUTE

$$WITH x AS (SELECT control_id, hl7_msg AS hm FROM rap_hl7 WHERE control_id = $1),
r AS (SELECT unnest(xpath('/HL7Message/NTE', hm)) AS hmr FROM x)
  SELECT
    CAST((xpath('/NTE/NTE.1/NTE.1.1/text()', hmr))[1] AS TEXT)::INTEGER,
    to_timestamp(CAST((xpath('/NTE/NTE.3/NTE.3.1/text()', hmr))[1] AS TEXT), 'YYYYMMDDHH24MISS')::TIMESTAMP WITHOUT TIME ZONE,
    CAST((xpath('/NTE/NTE.4/NTE.4.1/text()', hmr))[1] AS TEXT)::INTEGER,
    CAST((xpath('/NTE/NTE.4/NTE.4.2/text()', hmr))[1] AS TEXT),
    CAST((xpath('/NTE/NTE.4/NTE.4.4/text()', hmr))[1] AS VARCHAR),
    control_id,
    (SELECT id FROM company WHERE code = CAST((xpath('/HL7Message/MSH/MSH.4/MSH.4.1/text()', hm))[1] AS VARCHAR))
 FROM x, r$$
USING _cid;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_rap_nte(VARCHAR)
  OWNER TO fluance;
