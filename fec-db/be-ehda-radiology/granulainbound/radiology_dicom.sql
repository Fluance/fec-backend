-- Table: radiology_dicom

CREATE TABLE radiology_dicom (
    control_id VARCHAR(255) NOT NULL,
    dicom_msg XML NOT NULL,
    uploaded TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    CONSTRAINT radiology_dicom_pkey PRIMARY KEY (control_id)
);

ALTER TABLE radiology_dicom
OWNER TO fluance;
