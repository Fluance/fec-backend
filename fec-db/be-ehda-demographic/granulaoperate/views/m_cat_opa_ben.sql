/*
	Materialized View: m_cat_opa_ben

	Materialized view used to provide the description of the benefit code

	See also:
		<catalog>
*/

CREATE MATERIALIZED VIEW m_cat_opa_ben AS
  SELECT *
  FROM catalog
  WHERE type = 'BENEFIT'
  ORDER BY lang,code;

ALTER TABLE m_cat_opa_ben
  OWNER TO dbinput;

GRANT ALL ON TABLE m_cat_opa_ben TO fluance;

CREATE UNIQUE INDEX un_m_cat_opa_ben_code_lang
  ON m_cat_opa_ben
  USING btree
  (code, lang);
