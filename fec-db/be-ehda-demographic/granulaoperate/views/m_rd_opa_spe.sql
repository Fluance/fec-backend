/*
	Materialized View: m_rd_opa_spe

	Materialized view used to display the description of the physician speciality

	See also:
		<refdata>
*/

CREATE MATERIALIZED VIEW m_rd_opa_spe AS
  SELECT refdata.code AS code,
    company.id AS company_id,
    codedesc AS physpecialitydesc
  FROM refdata JOIN company ON (refdata.company = company.code)
  WHERE src = 'DEMOGRAPHIC' AND srctable = 'TBS.OPA.SPECIA'
  ORDER BY company_id, code;

ALTER TABLE m_rd_opa_spe
  OWNER TO dbinput;

GRANT ALL ON TABLE m_rd_opa_spe TO fluance;

CREATE UNIQUE INDEX un_m_rd_opa_spe_comp_code
  ON m_rd_opa_spe
  USING btree
  (company_id,code);
