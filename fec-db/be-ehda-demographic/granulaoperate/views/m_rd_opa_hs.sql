/*
	Materialized View: m_rd_opa_hs

	Materialized view used to display the description of the hospservice

	See also:
		<refdata>
*/

CREATE MATERIALIZED VIEW m_rd_opa_hs AS
  SELECT refdata.code AS code,
    company.id AS company_id,
    codedesc AS hospservicedesc
  FROM refdata
    JOIN company ON (refdata.company = company.code)
  WHERE src = 'DEMOGRAPHIC' AND srctable = 'TBS.OPA.SERV'
  ORDER BY company_id, code;

ALTER TABLE m_rd_opa_hs
  OWNER TO dbinput;

GRANT ALL ON TABLE m_rd_opa_hs TO fluance;

CREATE UNIQUE INDEX un_m_rd_opa_hs_comp_code
  ON m_rd_opa_hs
  USING btree
  (company_id,code);
