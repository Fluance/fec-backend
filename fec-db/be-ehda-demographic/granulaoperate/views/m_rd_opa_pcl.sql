/*
	Materialized View: m_rd_opa_pcl

	Materialized view used to display the description of the patient class

	See also:
		<refdata>
*/

CREATE MATERIALIZED VIEW m_rd_opa_pcl AS
  SELECT refdata.code AS code,
    refdata.hl7code,
    company.id AS company_id,
    codedesc AS patientclassdesc
  FROM refdata
    JOIN company ON (refdata.company = company.code)
  WHERE src = 'DEMOGRAPHIC' AND srctable = 'TBS.OPA.TYPADM'
  ORDER BY company_id, code;

ALTER TABLE m_rd_opa_pcl
  OWNER TO dbinput;

GRANT ALL ON TABLE m_rd_opa_pcl TO fluance;

CREATE UNIQUE INDEX un_m_rd_opa_pcl_comp_code
  ON m_rd_opa_pcl
  USING btree
  (company_id,code);
