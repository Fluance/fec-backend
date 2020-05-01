-- Table: patient

-- DROP TABLE patient;

CREATE TABLE patient
(
  id bigint NOT NULL,
  refnb character varying(255),
  lastname character varying(255) NOT NULL,
  firstname character varying(255) NOT NULL,
  maidenname character varying(255),
  mothername character varying(255),
  fathername character varying(255),
  spousename character varying(255),
  courtesy character varying(255),
  birthplace character varying(255),
  birthdate date,
  origin character varying(255),
  nationality character varying(255),
  sex character varying(20),
  address character varying(255),
  address2 character varying(255),
  careof character varying(255),
  locality character varying(255),
  postcode character varying(255),
  subpostcode character varying(255),
  canton character varying(255),
  country character varying(255),
  complement character varying(255),
  maritalstatus character varying(255),
  language character varying(255),
  confession character varying(255),
  avsnb character(16),
  oldavsnb character(14),
  passportnb character varying(255),
  mothervnb bigint,
  jobtitle character varying(255),
  employer character varying(255),
  workplace character varying(255),
  incorporation character varying(255),
  deadbeat boolean,
  death boolean,
  deathdt timestamp without time zone,
  source character varying(50),
  sourceid character varying(255),
  lastmodified timestamp without time zone,
  CONSTRAINT patient_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE patient
  OWNER TO fluance;

-- Index: idx_gin_patient_lastname

CREATE INDEX idx_gin_patient_lastname
  ON patient
  USING gin
  (lastname gin_trgm_ops);

-- Index: idx_gin_patient_firstname

CREATE INDEX idx_gin_patient_firstname
  ON patient
  USING gin
  (firstname gin_trgm_ops);

-- Index: idx_gin_patient_maidenname

CREATE INDEX idx_gin_patient_maidenname
  ON patient
  USING gin
  (maidenname gin_trgm_ops);

-- Index: idx_patient_bdate

CREATE INDEX idx_patient_bdate
  ON patient
  USING btree
  (birthdate);

-- Index: idx_gin_patient_id

CREATE INDEX idx_gin_patient_id
  ON patient
  USING gin
  (CAST (id AS TEXT) gin_trgm_ops);

-- Index: idx_gin_patient_unaccent_firstname

CREATE INDEX idx_gin_patient_unaccent_firstname
  ON patient
  USING gin
  (f_unaccent(firstname) gin_trgm_ops);

-- Index: idx_gin_patient_unaccent_lastname

CREATE INDEX idx_gin_patient_unaccent_lastname
  ON patient
  USING gin
  (f_unaccent(lastname) gin_trgm_ops);
