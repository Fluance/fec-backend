-- Materialized View: m_h2t_ic

CREATE MATERIALIZED VIEW m_h2t_ic AS
  SELECT code AS abnormalflag,
    description AS abnormalflagdesc
  FROM hl7v2tables
  WHERE id = '0078'
  ORDER BY abnormalflag;

ALTER TABLE m_h2t_ic
  OWNER TO dbinput;

GRANT ALL ON TABLE m_h2t_ic TO fluance;

CREATE UNIQUE INDEX un_m_h2t_ic_abn
  ON m_h2t_ic
  USING btree
  (abnormalflag);
