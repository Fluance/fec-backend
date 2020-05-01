/*

    Function: fdw_rap_aig

        This function returns a table which represents the usefull data of aig segment for a specific record from granulainbound rap_hl7 table.



    Parameters:



        _cid - control id of the record



    Returns:

        SQL Table



    See also:

        <rap_hl7>, <company>

*/
CREATE FUNCTION fdw_rap_aig(_cid VARCHAR) RETURNS TABLE (aig_3_1 integer, aig_3_2 character varying, aig_3_3 character varying, aig_3_5 character varying, aig_3_6 character varying, aig_3_7 character varying, aig_3_8 character varying, aig_3_9 character varying, 
aig_3_10 character varying, aig_3_11 character varying, aig_3_12 character varying, aig_3_13 character varying, aig_3_14 character varying, aig_4_1 character varying, aig_5_4 character varying, aig_8_1 TIMESTAMP WITHOUT time ZONE, aig_11_1 integer, control_id character varying, company_id integer) AS $BODY$

BEGIN

RETURN QUERY EXECUTE

$$WITH
x AS (SELECT control_id, hl7_msg AS hm FROM rap_hl7 WHERE control_id = $1),
r AS (SELECT unnest(xpath('/HL7Message/AIG', hm)) AS hmr FROM x)
  SELECT
    CAST((xpath('/AIG/AIG.3/AIG.3.1/text()', hmr))[1] AS TEXT)::INTEGER,
    CAST((xpath('/AIG/AIG.3/AIG.3.2/text()', hmr))[1] AS TEXT)::VARCHAR,
    CAST((xpath('/AIG/AIG.3/AIG.3.3/text()', hmr))[1] AS TEXT)::VARCHAR,
    CAST((xpath('/AIG/AIG.3/AIG.3.5/text()', hmr))[1] AS TEXT)::VARCHAR,
    CAST((xpath('/AIG/AIG.3/AIG.3.6/text()', hmr))[1] AS TEXT)::VARCHAR,
    CAST((xpath('/AIG/AIG.3/AIG.3.7/text()', hmr))[1] AS TEXT)::VARCHAR,
    CAST((xpath('/AIG/AIG.3/AIG.3.8/text()', hmr))[1] AS TEXT)::VARCHAR,
    CAST((xpath('/AIG/AIG.3/AIG.3.9/text()', hmr))[1] AS TEXT)::VARCHAR,
    CAST((xpath('/AIG/AIG.3/AIG.3.10/text()', hmr))[1] AS TEXT)::VARCHAR,
    CAST((xpath('/AIG/AIG.3/AIG.3.11/text()', hmr))[1] AS TEXT)::VARCHAR,
    CAST((xpath('/AIG/AIG.3/AIG.3.12/text()', hmr))[1] AS TEXT)::VARCHAR,
    CAST((xpath('/AIG/AIG.3/AIG.3.13/text()', hmr))[1] AS TEXT)::VARCHAR,
    CAST((xpath('/AIG/AIG.3/AIG.3.14/text()', hmr))[1] AS TEXT)::VARCHAR,
    CAST((xpath('/AIG/AIG.4/AIG.4.1/text()', hmr))[1] AS TEXT)::VARCHAR,
    CAST((xpath('/AIG/AIG.5/AIG.5.4/text()', hmr))[1] AS TEXT)::VARCHAR,
    to_timestamp(CAST((xpath('/AIG/AIG.8/AIG.8.1/text()', hmr))[1] AS TEXT), 'YYYYMMDDHH24MISS')::TIMESTAMP WITHOUT TIME ZONE,
    CAST((xpath('/AIG/AIG.11/AIG.11.1/text()', hmr))[1] AS TEXT)::INTEGER,
    control_id,
    (SELECT id FROM company WHERE code = CAST((xpath('/HL7Message/MSH/MSH.4/MSH.4.1/text()', hm))[1] AS VARCHAR))
 FROM x, r$$
USING _cid;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_rap_aig(VARCHAR)
  OWNER TO fluance;
