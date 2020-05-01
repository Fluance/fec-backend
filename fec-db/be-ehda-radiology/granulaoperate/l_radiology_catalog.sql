CREATE TEMP TABLE catalog_tmp AS SELECT * FROM catalog WITH NO DATA;

\COPY catalog_tmp (code, description) FROM 'datafiles/dicom-modality.csv' WITH DELIMITER E'\t' CSV HEADER ENCODING 'UTF-8' NULL '';

UPDATE catalog_tmp set type = 'DICOM', lang = 'en';

INSERT INTO catalog (code, lang, description, type) SELECT code, lang, description, type FROM catalog_tmp;

DROP TABLE catalog_tmp;

REFRESH MATERIALIZED VIEW CONCURRENTLY m_cat_tel_dicom WITH DATA;