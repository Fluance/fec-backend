/*
	Materialized View: m_rd_opa_pca

	Materialized view used to display the description of the patient case

	See also:
		<refdata>
*/

CREATE MATERIALIZED VIEW m_rd_opa_pca AS
  SELECT refdata.code AS code,
    company.id AS company_id,
    codedesc AS patientcasedesc
  FROM refdata
    JOIN company ON (refdata.company = company.code)
  WHERE src = 'DEMOGRAPHIC' AND srctable = 'TBS.OPA.CAS'
  ORDER BY company_id, code;

ALTER TABLE m_rd_opa_pca
  OWNER TO dbinput;

GRANT ALL ON TABLE m_rd_opa_pca TO fluance;

CREATE UNIQUE INDEX un_m_rd_opa_pca_comp_code
  ON m_rd_opa_pca
  USING btree
  (company_id,code);
