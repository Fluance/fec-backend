/*
	Materialized View: m_cat_opa_icd

	Materialized view used to provide the details of ICD codes

	See also:
		<catalog>
*/

CREATE MATERIALIZED VIEW m_cat_opa_icd AS
  SELECT *
  FROM catalog
  WHERE type = 'ICD'
  ORDER BY lang,code;

ALTER TABLE m_cat_opa_icd
  OWNER TO dbinput;

GRANT ALL ON TABLE m_cat_opa_icd TO fluance;

CREATE UNIQUE INDEX un_m_cat_opa_icd_code_lang
  ON m_cat_opa_icd
  USING btree
  (code, lang);
