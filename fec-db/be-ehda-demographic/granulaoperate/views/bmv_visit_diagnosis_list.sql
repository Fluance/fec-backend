/*
	View: bmv_visit_diagnosis_list

	View used to provide a list of diagnosis codes for a visit

	See also:
		<visit_healthcare>
*/

CREATE OR REPLACE VIEW bmv_visit_diagnosis_list AS
SELECT op.visit_nb,
    op.data,
    UPPER(type) AS type,
    op.rank
FROM visit_healthcare op WHERE type = 'diagnosis';

ALTER TABLE bmv_visit_diagnosis_list
OWNER TO fluance;
