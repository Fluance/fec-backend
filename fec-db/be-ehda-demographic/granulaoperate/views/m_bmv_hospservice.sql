/*
	Materialized View: m_bmv_hospservice

	Materialized view used to provide a list of current (hosp) services for each company

	See also:
		<visit>
*/

CREATE MATERIALIZED VIEW m_bmv_hospservice AS
  SELECT s.hospservice,
    moh.hospservicedesc,
    s.company_id
  FROM (SELECT v.hospservice, v.company_id FROM visit v JOIN company c ON (v.company_id = c.id) WHERE v.hospservice IS NOT NULL GROUP BY v.hospservice, v.company_id) s
  LEFT JOIN m_rd_opa_hs moh ON (s.hospservice = moh.code AND s.company_id = moh.company_id)
  ORDER BY s.company_id, s.hospservice;

ALTER TABLE m_bmv_hospservice
  OWNER TO dbinput;

GRANT ALL ON TABLE m_bmv_hospservice TO fluance;

CREATE UNIQUE INDEX un_mbmv_hs_comp_hs
  ON m_bmv_hospservice
  USING btree
  (company_id,hospservice);
