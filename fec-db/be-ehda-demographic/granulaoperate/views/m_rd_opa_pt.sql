/*
	Materialized View: m_rd_opa_pt

	Materialized view used to display the description of the patient type

	See also:
		<refdata>
*/

CREATE MATERIALIZED VIEW m_rd_opa_pt AS
  SELECT refdata.code AS code,
    company.id AS company_id,
    codedesc AS patienttypedesc
  FROM refdata
    JOIN company ON (refdata.company = company.code)
  WHERE src = 'DEMOGRAPHIC' AND srctable = 'TBS.OPA.STATAD'
  ORDER BY company_id, code;

ALTER TABLE m_rd_opa_pt
  OWNER TO dbinput;

GRANT ALL ON TABLE m_rd_opa_pt TO fluance;

CREATE UNIQUE INDEX un_m_rd_opa_pt_comp_code
  ON m_rd_opa_pt
  USING btree
  (company_id,code);
