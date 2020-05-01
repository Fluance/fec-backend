/*
	Materialized View: m_bmv_patientroom

	Materialized view used to provide a list of current rooms for each company

	See also:
		<visit>
*/

CREATE MATERIALIZED VIEW m_bmv_patientroom AS
  SELECT DISTINCT(v.patientroom),
    v.patientunit,
    v.hospservice,
    v.company_id
  FROM visit v
  WHERE (v.patientunit IS NOT NULL OR v.hospservice IS NOT NULL)
  ORDER BY v.company_id,v.patientunit,v.hospservice,v.patientroom;

ALTER TABLE m_bmv_patientroom
  OWNER TO dbinput;

GRANT ALL ON TABLE m_bmv_patientroom TO fluance;

CREATE UNIQUE INDEX idx_u_mbmv_pr
  ON m_bmv_patientroom
  USING btree
  (company_id,patientunit,hospservice, patientroom);


CREATE INDEX idx_mbmv_pr_unit
  ON m_bmv_patientroom
  USING btree
  (patientunit);

CREATE INDEX idx_mbmv_pr_hosp
  ON m_bmv_patientroom
  USING btree
  (hospservice);

CREATE INDEX idx_mbmv_pr_comp
  ON m_bmv_patientroom
  USING btree
  (company_id);
