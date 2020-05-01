/*
	Materialized View: m_rd_opa_at

	Materialized view used to display the description of the admission type

	See also:
		<refdata>
*/

CREATE MATERIALIZED VIEW m_rd_opa_at AS
  SELECT refdata.code AS code,
    company.id AS company_id,
    codedesc AS admissiontypedesc
  FROM refdata
    JOIN company ON (refdata.company = company.code)
  WHERE src = 'DEMOGRAPHIC' AND srctable = 'TBS.OPA.GENRE'
  ORDER BY company_id, code;

ALTER TABLE m_rd_opa_at
  OWNER TO dbinput;

GRANT ALL ON TABLE m_rd_opa_at TO fluance;

CREATE UNIQUE INDEX un_m_rd_opa_at_comp_code
  ON m_rd_opa_at
  USING btree
  (company_id,code);
