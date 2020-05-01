/*
        Materialized View: m_cat_tel_dicom

        Materialized view used to provide the descriptions of DICOM values

        See also:
                <catalog>
*/

CREATE MATERIALIZED VIEW m_cat_tel_dicom AS
  SELECT *
  FROM catalog
  WHERE type = 'DICOM'
  ORDER BY lang,code;

ALTER TABLE m_cat_tel_dicom
  OWNER TO dbinput;

GRANT ALL ON TABLE m_cat_tel_dicom TO fluance;

CREATE UNIQUE INDEX un_m_cat_tel_dicom_code_lang
  ON m_cat_tel_dicom
  USING btree
  (code, lang);