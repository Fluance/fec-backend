/*
	Materialized View: m_rd_opa_as

	Materialized view used to display the description of the admission source

	See also:
		<refdata>
*/

CREATE MATERIALIZED VIEW m_rd_opa_as AS
  SELECT refdata.code AS code,
    company.id AS company_id,
    codedesc AS admitsourcedesc
  FROM refdata
    JOIN company ON (refdata.company = company.code)
  WHERE src = 'DEMOGRAPHIC' AND srctable = 'TBS.OPA.MODENT'
  ORDER BY company_id, code;

ALTER TABLE m_rd_opa_as
  OWNER TO dbinput;

GRANT ALL ON TABLE m_rd_opa_as TO fluance;

CREATE UNIQUE INDEX un_m_rd_opa_as_comp_code
  ON m_rd_opa_as
  USING btree
  (company_id,code);
