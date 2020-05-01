/*
	View: bmv_guarantor_detail

	View used to provide the full detail of a guarantor

	See also:
		<guarantor>
*/

CREATE OR REPLACE VIEW bmv_guarantor_detail AS
 SELECT g.id,
	g.code,
	g.name,
	g.address,
	g.address2,
	g.locality,
	g.postcode,
	g.canton,
	g.country,
	g.complement,
	g.begindate,
	g.enddate,
	g.occasional
 FROM guarantor g;

ALTER TABLE bmv_guarantor_detail
  OWNER TO fluance;