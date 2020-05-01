/*
	Materialized View: m_bmv_patientcase

	Materialized view used to provide a list of current patient cases for each company

	See also:
		<visit>
*/

CREATE MATERIALIZED VIEW m_bmv_patientcase AS
  SELECT s.patientcase,
    mop.patientcasedesc,
    s.company_id
  FROM (SELECT v.patientcase, v.company_id FROM visit v JOIN company c ON (v.company_id = c.id) WHERE v.patientcase IS NOT NULL GROUP BY v.patientcase, v.company_id) s 
  LEFT JOIN m_rd_opa_pca mop ON (s.patientcase = mop.code AND s.company_id = mop.company_id)
  ORDER BY s.company_id, s.patientcase;

ALTER TABLE m_bmv_patientcase
  OWNER TO dbinput;

GRANT ALL ON TABLE m_bmv_patientcase TO fluance;

CREATE UNIQUE INDEX un_mbmv_pc_comp_pc
  ON m_bmv_patientcase
  USING btree
  (company_id,patientcase);
