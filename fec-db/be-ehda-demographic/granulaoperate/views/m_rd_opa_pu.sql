/*
	Materialized View: m_rd_opa_pu

	Materialized view used to display the description of the patient unit

	See also:
		<refdata>
*/

CREATE MATERIALIZED VIEW m_rd_opa_pu AS
  SELECT refdata.code AS code,
    company.id AS company_id,
    codedesc AS patientunitdesc
  FROM refdata
    JOIN company ON (refdata.company = company.code)
  WHERE src = 'DEMOGRAPHIC' AND srctable = 'TBS.OPA.UNITE'
  ORDER BY company_id, code;

ALTER TABLE m_rd_opa_pu
  OWNER TO dbinput;

GRANT ALL ON TABLE m_rd_opa_pu TO fluance;

CREATE UNIQUE INDEX un_m_rd_opa_pu_comp_code
  ON m_rd_opa_pu
  USING btree
  (company_id,code);
