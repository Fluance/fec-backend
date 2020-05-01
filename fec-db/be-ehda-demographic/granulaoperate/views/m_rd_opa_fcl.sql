/*
	Materialized View: m_rd_opa_fcl

	Materialized view used to display the description of the financial class

	See also:
		<refdata>
*/

CREATE MATERIALIZED VIEW m_rd_opa_fcl AS
  SELECT refdata.code AS code,
    company.id AS company_id,
    codedesc AS financialclassdesc
  FROM refdata JOIN company ON (refdata.company = company.code)
  WHERE src = 'DEMOGRAPHIC' AND srctable = 'TBS.OPA.CLASSE'
  ORDER BY company_id, code;

ALTER TABLE m_rd_opa_fcl
  OWNER TO dbinput;

GRANT ALL ON TABLE m_rd_opa_fcl TO fluance;

CREATE UNIQUE INDEX un_m_rd_opa_fcl_comp_code
  ON m_rd_opa_fcl
  USING btree
  (company_id,code);
