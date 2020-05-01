/*
	Materialized View: m_bmv_patientbed

	Materialized view used to provide a list of beds for each company

	See also:
		<visit>
*/

CREATE MATERIALIZED VIEW m_bmv_patientbed AS
  SELECT DISTINCT(v.patientbed),
    v.patientunit,
    v.hospservice,
    v.patientroom,
    v.company_id
  FROM visit v
  WHERE (v.patientunit IS NOT NULL OR v.hospservice IS NOT NULL)
  ORDER BY v.company_id,v.patientunit,v.hospservice,v.patientroom,v.patientbed;

ALTER TABLE m_bmv_patientbed
  OWNER TO dbinput;

GRANT ALL ON TABLE m_bmv_patientbed TO fluance;

CREATE UNIQUE INDEX idx_u_mbmv_pb
  ON m_bmv_patientbed
  USING btree
  (company_id,patientunit,hospservice, patientroom, patientbed);


CREATE INDEX idx_mbmv_pb_room
  ON m_bmv_patientbed
  USING btree
  (patientroom);

CREATE INDEX idx_mbmv_pb_unit
  ON m_bmv_patientbed
  USING btree
  (patientunit);

CREATE INDEX idx_mbmv_pb_hosp
  ON m_bmv_patientbed
  USING btree
  (hospservice);

CREATE INDEX idx_mbmv_pb_comp
  ON m_bmv_patientbed
  USING btree
  (company_id);
