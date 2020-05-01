/*
	Function: fdw_demographic_adt_gt1
	
	This function returns a table which represent the usefull data of adt_gt1 segment from granulainbound demographic_hl7 table.

	Parameters:
		_cid - control id of the record

	Returns:
		SQL TABLE

	See also:
		<demographic_hl7>
*/
CREATE FUNCTION fdw_demographic_adt_gt1(_cid VARCHAR)
RETURNS TABLE (gt1_2_1 character varying, gt1_3_1 character varying, gt1_5_1 character varying, gt1_5_2 character varying, gt1_5_3 character varying, gt1_5_4 character varying, gt1_5_5 character varying, gt1_5_6 character varying, gt1_5_9 character varying, gt1_11_1 character varying, gt1_11_2 date, gt1_13_1 date,
gt1_14_1 date, gt1_15_1 smallint, gt1_16_1 numeric(20,0), gt1_19_1 character varying, gt1_25_1 boolean, gt1_29_1 smallint, gt1_54_1 character varying, control_id character varying, companycode character varying) AS $BODY$

BEGIN

RETURN QUERY EXECUTE
$$WITH x AS (SELECT control_id, hl7_msg AS hm FROM demographic_hl7 WHERE control_id = $1),
r AS (SELECT unnest(xpath('/HL7Message/GT1', hm)) AS hmr FROM x)
 SELECT CAST((xpath('/GT1/GT1.2/GT1.2.1/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/GT1/GT1.3/GT1.3.1/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/GT1/GT1.5/GT1.5.1/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/GT1/GT1.5/GT1.5.2/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/GT1/GT1.5/GT1.5.3/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/GT1/GT1.5/GT1.5.4/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/GT1/GT1.5/GT1.5.5/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/GT1/GT1.5/GT1.5.6/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/GT1/GT1.5/GT1.5.9/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/GT1/GT1.11/GT1.11.1/text()', hmr))[1] AS VARCHAR),
    to_date(CAST((xpath('/GT1/GT1.11/GT1.11.2/text()', hmr))[1] AS TEXT), 'YYYYMMDD'),
    to_date(CAST((xpath('/GT1/GT1.13/GT1.13.1/text()', hmr))[1] AS TEXT), 'YYYYMMDD'),
    to_date(CAST((xpath('/GT1/GT1.14/GT1.14.1/text()', hmr))[1] AS TEXT), 'YYYYMMDD'),
    CAST((xpath('/GT1/GT1.15/GT1.15.1/text()', hmr))[1] AS TEXT)::SMALLINT,
    CAST((xpath('/GT1/GT1.16/GT1.16.1/text()', hmr))[1] AS TEXT)::NUMERIC(20,0),
    CAST((xpath('/GT1/GT1.19/GT1.19.1/text()', hmr))[1] AS VARCHAR),
    CAST((xpath('/GT1/GT1.25/GT1.25.1/text()', hmr))[1] AS TEXT)::BOOLEAN,
    CAST((xpath('/GT1/GT1.29/GT1.29.1/text()', hmr))[1] AS TEXT)::SMALLINT,
    CAST((xpath('/GT1/GT1.54/GT1.54.1/text()', hmr))[1] AS VARCHAR),
    control_id,
    CAST((xpath('/HL7Message/MSH/MSH.4/MSH.4.1/text()', hm))[1] AS VARCHAR)
 FROM r, x WHERE xmlexists('/HL7Message/GT1' PASSING BY REF hm)$$
USING _cid;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_demographic_adt_gt1(VARCHAR)
  OWNER TO fluance;
