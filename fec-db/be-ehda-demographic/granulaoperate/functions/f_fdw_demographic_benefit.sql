/*
	Function: fdw_demographic_benefit
	
	This function returns a table which represent the usefull data of a specific benefit from granulainbound demographic_hl7 table.

	Parameters:
		_control_id - control id of the record

	Returns:
		SQL table

	See also:
		<demographic_exp10_benefit>
*/
CREATE OR REPLACE FUNCTION fdw_demographic_benefit(_control_id uuid)
RETURNS TABLE (mutation_code smallint, visit_nb bigint, internalnb integer, sequencenb integer, form_code character varying, benefitdt timestamp without time zone,
    benefit_code character varying, quantity numeric, acting_department character varying,  acting_department_description character varying, operating_physician integer, paid_physician integer, lead_physician integer, benefit_side character,
    benefit_description character varying, note character varying, visa_last_modifier character varying, date_last_modified timestamp without time zone, control_id uuid) LANGUAGE sql AS

$BODY$
 SELECT (oeb.exp10_msg#>>'{EXP10message, 0}')::SMALLINT AS mutation_code,
  (oeb.exp10_msg#>>'{EXP10message, 1}')::BIGINT AS visit_nb,
  (oeb.exp10_msg#>>'{EXP10message, 2}')::INTEGER AS internalnb,
  (oeb.exp10_msg#>>'{EXP10message, 3}')::integer AS sequencenb,
  (oeb.exp10_msg#>>'{EXP10message, 4}')::VARCHAR AS form_code,
  to_timestamp((oeb.exp10_msg#>>'{EXP10message, 5}')::TEXT, 'YYYY.MM.DD HH24:MI')::TIMESTAMP WITHOUT TIME ZONE AS benefitdt,
  (oeb.exp10_msg#>>'{EXP10message, 6}')::VARCHAR AS benefit_code,
  (oeb.exp10_msg#>>'{EXP10message, 7}')::NUMERIC AS quantity,
  (oeb.exp10_msg#>>'{EXP10message, 8}')::VARCHAR AS acting_department,
  (oeb.exp10_msg#>>'{EXP10message, 9}')::VARCHAR AS acting_department_description,
  (SELECT id AS operating_physician FROM physician WHERE company_id = lat.company_id AND staffid = (oeb.exp10_msg#>>'{EXP10message, 10}')::INTEGER)::INTEGER AS operating_physician,
  (SELECT id AS paid_physician FROM physician WHERE company_id = lat.company_id AND staffid = (oeb.exp10_msg#>>'{EXP10message, 11}')::INTEGER)::INTEGER AS paid_physician,
  (SELECT id AS lead_physician FROM physician WHERE company_id = lat.company_id AND staffid = (oeb.exp10_msg#>>'{EXP10message, 12}')::INTEGER)::INTEGER AS lead_physician,
  (oeb.exp10_msg#>>'{EXP10message, 13}')::CHARACTER AS benefit_side,
  (oeb.exp10_msg#>>'{EXP10message, 14}')::VARCHAR AS benefit_description,
  (oeb.exp10_msg#>>'{EXP10message, 15}')::VARCHAR AS note,
  (oeb.exp10_msg#>>'{EXP10message, 16}')::VARCHAR AS visa_last_modifier,
  to_timestamp((oeb.exp10_msg#>>'{EXP10message, 17}')::TEXT, 'YYYY.MM.DD HH24:MI')::TIMESTAMP WITHOUT TIME ZONE AS date_last_modified,
  oeb.control_id
 FROM demographic_exp10_benefit oeb LEFT JOIN LATERAL (SELECT company_id FROM visit v WHERE v.nb = (oeb.exp10_msg#>>'{EXP10message, 1}')::BIGINT ) AS lat on true
 WHERE oeb.control_id = $1;

$BODY$;

ALTER FUNCTION fdw_demographic_benefit(uuid)
  OWNER TO fluance;
