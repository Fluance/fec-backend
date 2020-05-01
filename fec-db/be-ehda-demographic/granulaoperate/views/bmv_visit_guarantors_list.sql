/*
	View: bmv_visit_guarantors_list

	View used to provide a list of guarantor declared in a visit

	See also:
		<visit_guarantor>
*/

CREATE OR REPLACE VIEW bmv_visit_guarantors_list AS
 SELECT v.nb,
	vg.priority,
	vg.subpriority,
	vg.accidentnb,
	vg.accidentdate,
	vg.begindate,
	vg.enddate,
	vg.covercardnb,
	vg.policynb,
	vg.inactive,
	vg.hospclass,
	g.id,
	g.code,
	g.name
 FROM visit v JOIN visit_guarantor vg ON (v.nb = vg.visit_nb) JOIN guarantor g ON (vg.guarantor_id = g.id);

ALTER TABLE bmv_visit_guarantors_list
  OWNER TO fluance;
