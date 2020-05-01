/*
	Materialized View: m_rd_opa_dtl

	Materialized view used to display the description of the patient destination

	See also:
		<refdata>
*/

CREATE MATERIALIZED VIEW m_rd_opa_dtl AS
  SELECT refdata.code AS code,
    company.id AS company_id,
    codedesc AS dischargetolocdesc
  FROM refdata
    JOIN company ON (refdata.company = company.code)
  WHERE src = 'DEMOGRAPHIC' AND srctable = 'TBS.OPA.DESTI'
  ORDER BY company_id, code;

ALTER TABLE m_rd_opa_dtl
  OWNER TO dbinput;

GRANT ALL ON TABLE m_rd_opa_dtl TO fluance;

CREATE UNIQUE INDEX un_m_rd_opa_dtl_comp_code
  ON m_rd_opa_dtl
  USING btree
  (company_id,code);
