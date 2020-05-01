/*
	Materialized View: m_rd_opa_input

	Materialized view used to store the description instead of the code for the following data:
		- canton
		- confession
		- etat civil
		- langue
		- pays
		- sexe
		- type d'adresse

	See also:
		<refdata>
*/

CREATE MATERIALIZED VIEW m_rd_opa_input AS
  SELECT refdata.srctable as srctable,
    refdata.code AS code,
    company.id AS company_id,
    codedesc
  FROM refdata
    JOIN company ON (refdata.company = company.code)
  WHERE src = 'DEMOGRAPHIC' AND srctable IN ('TBS.OPA.CANTON','TBS.OPA.CONF','TBS.OPA.ETACIV','TBS.OPA.LANG','TBS.OPA.PAYS','TBS.OPA.SEXE','TBS.OPA.TYPADR')
  ORDER BY srctable, company_id, code;

ALTER TABLE m_rd_opa_input
  OWNER TO dbinput;

GRANT ALL ON TABLE m_rd_opa_input TO fluance;

CREATE UNIQUE INDEX un_m_rd_opa_input_src_comp_code
  ON m_rd_opa_input
  USING btree
  (srctable,company_id,code);
