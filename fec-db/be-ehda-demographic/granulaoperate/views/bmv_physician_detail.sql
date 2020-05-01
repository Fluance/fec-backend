/*
	View: bmv_physician_detail

	View used to provide the full detail of a physician

	See also:
		<physician>, <m_rd_opa_spe>
*/

CREATE OR REPLACE VIEW bmv_physician_detail AS
 SELECT p.id,
	p.lastname,
	p.firstname,
	p.prefix,
	p.staffid,
	p.alternateid,
	p.alternateidname,
	p.speciality,
	p.address,
	p.locality,
	p.postcode,
	p.canton,
	p.country,
	p.complement,
	p.language,
	p.startdate,
	p.enddate,
	p.company_id,
	physpecialitydesc
 FROM physician p LEFT JOIN m_rd_opa_spe ON
                (p.speciality = m_rd_opa_spe.code AND p.company_id = m_rd_opa_spe.company_id);

ALTER TABLE bmv_physician_detail
  OWNER TO fluance;
