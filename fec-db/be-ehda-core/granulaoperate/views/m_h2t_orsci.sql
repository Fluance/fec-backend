-- Materialized View: m_h2t_orsci

CREATE MATERIALIZED VIEW m_h2t_orsci AS
  SELECT code AS resultstatus,
    description AS resultstatusdesc
  FROM hl7v2tables
  WHERE id = '0085'
  ORDER BY resultstatus;

ALTER TABLE m_h2t_orsci
  OWNER TO dbinput;

GRANT ALL ON TABLE m_h2t_orsci TO fluance;

CREATE UNIQUE INDEX un_m_h2t_orsci_res
  ON m_h2t_orsci
  USING btree
  (resultstatus);
