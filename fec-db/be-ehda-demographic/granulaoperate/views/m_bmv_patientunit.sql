/*
	Materialized View: m_bmv_patientunit

	Materialized view used to provide a list of current patient units for each company

	See also:
		<visit>
*/

CREATE MATERIALIZED VIEW m_bmv_patientunit AS
  SELECT s.patientunit,
    mop.patientunitdesc,
    s.company_id
  FROM (SELECT v.patientunit, v.company_id FROM visit v JOIN company c ON (v.company_id = c.id) WHERE v.patientunit IS NOT NULL GROUP BY v.patientunit, v.company_id) s
  LEFT JOIN m_rd_opa_pu mop ON (s.patientunit = mop.code AND s.company_id = mop.company_id)
  ORDER BY s.company_id, s.patientunit;

ALTER TABLE m_bmv_patientunit
  OWNER TO dbinput;

GRANT ALL ON TABLE m_bmv_patientunit TO fluance;

CREATE UNIQUE INDEX un_mbmv_pu_comp_pu
  ON m_bmv_patientunit
  USING btree
  (company_id,patientunit);
