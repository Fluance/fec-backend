/*
	Materialized View: m_cat_opa_icd

	Materialized view used to provide the details of CHOP codes

	See also:
		<catalog>
*/

CREATE MATERIALIZED VIEW m_cat_opa_chop AS
  SELECT *
  FROM catalog
  WHERE type = 'CHOP'
  ORDER BY lang,code;

ALTER TABLE m_cat_opa_chop
  OWNER TO dbinput;

GRANT ALL ON TABLE m_cat_opa_chop TO fluance;

CREATE UNIQUE INDEX un_m_cat_opa_chop_code_lang
  ON m_cat_opa_chop
  USING btree
  (code, lang);
