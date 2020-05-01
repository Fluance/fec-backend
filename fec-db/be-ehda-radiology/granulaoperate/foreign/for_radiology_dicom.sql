CREATE FOREIGN TABLE IF NOT EXISTS radiology_dicom
(
  control_id VARCHAR(255) NOT NULL,
  dicom_msg XML NOT NULL,
  uploaded TIMESTAMP WITHOUT TIME ZONE NOT NULL
)
SERVER forinbound
OPTIONS(updatable 'false');

ALTER TABLE radiology_dicom
  OWNER TO fluance;
