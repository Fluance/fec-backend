-- Table: visit

-- DROP TABLE visit;

CREATE TABLE visit
(
  nb bigint NOT NULL,
  patient_id bigint NOT NULL,
  patientclass character varying(255) NOT NULL,
  patientunit character varying(255),
  patientroom character varying(255),
  patientbed character varying(255),
  patientcase character varying(255),
  company_id integer NOT NULL,
  admissiontype character varying(20),
  priorunit character varying(255),
  priorroom character varying(255),
  priorbed character varying(255),
  hospservice character varying(20),
  inactiveres boolean,
  admitsource character varying(255),
  patienttype character varying(20),
  assigningauth character varying(255),
  financialclass character varying(255),
  chargepriceind character varying(20),
  sequencenb smallint,
  priormvtroom boolean,
  dischargedisp character varying(20),
  dischargetoloc character varying(255),
  dischargesupp character varying(255),
  accountstatus character varying(20),
  priorlocation character varying(255),
  admitdt timestamp without time zone,
  dischargedt timestamp without time zone,
  patientbalance numeric(9,2),
  fid smallint,
  visitindicator character varying(255),
  admitreason character varying(255),
  reside character varying(255),
  expadmitdt timestamp without time zone,
  expdischargedt timestamp without time zone,
  groupingfolder character varying(255),
  drgsplittingdate date,
  chargedfolder character varying(20),
  groupingreason character varying(255),
  interventiondt timestamp without time zone,
  freezone character varying(255),
  statzone1 character varying(255),
  statzone2 character varying(255),
  statzone3 character varying(255),
  statzone4 character varying(255),
  statzone5 character varying(255),
  admitstatus admit_status NOT NULL,
  source character varying(50),
  sourceid character varying(255),
  lastmodified timestamp without time zone,
  CONSTRAINT visit_pkey PRIMARY KEY (nb),
  CONSTRAINT fk_vis_com FOREIGN KEY (company_id)
      REFERENCES company (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_vis_pat FOREIGN KEY (patient_id)
      REFERENCES patient (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE RESTRICT
)
WITH (
  OIDS=FALSE
);
ALTER TABLE visit
  OWNER TO fluance;

-- Index: fki_vis_com

CREATE INDEX fki_vis_com
  ON visit
  USING btree
  (company_id);

-- Index: fki_vis_pat

CREATE INDEX fki_vis_pat
  ON visit
  USING btree
  (patient_id);

-- Index: idx_vis_admitdt

CREATE INDEX idx_vis_admitdt
  ON visit
  USING btree
  (admitdt DESC NULLS LAST);

-- Index: idx_vis_dischargedt

CREATE INDEX idx_vis_dischargedt
  ON visit
  USING btree
  (dischargedt DESC NULLS FIRST);

-- Index: idx_vis_patienttype

CREATE INDEX idx_vis_patienttype
  ON visit
  USING btree
  (patienttype);

-- Index: idx_vis_patientclass

CREATE INDEX idx_vis_patientclass
  ON visit
  USING btree
  (patientclass);

-- Index: idx_vis_patientcase

CREATE INDEX idx_vis_patientcase
  ON visit
  USING btree
  (patientcase);

-- Index: idx_vis_admissiontype

CREATE INDEX idx_vis_admissiontype
  ON visit
  USING btree
  (admissiontype);

-- Index: idx_vis_patientunit

CREATE INDEX idx_vis_patientunit
  ON visit
  USING btree
  (patientunit);

-- Index: idx_vis_patientroom

CREATE INDEX idx_vis_patientroom
  ON visit
  USING btree
  (patientroom);

-- Index: idx_vis_patientbed

CREATE INDEX idx_vis_patientbed
  ON visit
  USING btree
  (patientbed);

-- Index: idx_vis_hospservice

CREATE INDEX idx_vis_hospservice
  ON visit
  USING btree
  (hospservice);
