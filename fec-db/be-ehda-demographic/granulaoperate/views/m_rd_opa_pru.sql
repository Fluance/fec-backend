/*
	Materialized View: m_rd_opa_pru

	Materialized view used to display the description of the patient prior unit

	See also:
		<refdata>
*/

CREATE MATERIALIZED VIEW m_rd_opa_pru AS
  SELECT refdata.code AS code,
    company.id AS company_id,
    codedesc AS priorunitdesc
  FROM refdata
    JOIN company ON (refdata.company = company.code)
  WHERE src = 'DEMOGRAPHIC' AND srctable = 'TBS.OPA.UNITE'
  ORDER BY company_id, code;

ALTER TABLE m_rd_opa_pru
  OWNER TO dbinput;

GRANT ALL ON TABLE m_rd_opa_pru TO fluance;

CREATE UNIQUE INDEX un_m_rd_opa_pru_comp_code
  ON m_rd_opa_pru
  USING btree
  (company_id,code);
