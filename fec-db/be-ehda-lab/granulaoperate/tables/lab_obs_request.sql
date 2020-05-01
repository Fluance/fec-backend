-- Table: lab_obs_request

--DROP TABLE lab_obs_request;

CREATE TABLE lab_obs_request (
    id integer NOT NULL,
    ordernb character varying(255) NOT NULL,
    patient_id bigint NOT NULL,
    company_id integer NOT NULL,
    groupid character varying(255),
    groupname character varying(255),
    namespace character varying(255),
    observationdt timestamp without time zone NOT NULL,
    source character varying(255),
    sourceid character varying(255),
    lastmodified timestamp without time zone,
    CONSTRAINT lab_obs_request_pkey PRIMARY KEY(id, ordernb),
    CONSTRAINT fk_lab_obs_req_pat FOREIGN KEY (patient_id)
	REFERENCES patient (id) MATCH SIMPLE
	ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT fk_lab_obs_req_com FOREIGN KEY (company_id)
	REFERENCES company (id) MATCH SIMPLE
	ON UPDATE CASCADE ON DELETE RESTRICT
) WITH
(
  OIDS=FALSE
);

ALTER TABLE lab_obs_request
    OWNER TO fluance;

-- Index: fki_lab_obs_req_pat

CREATE INDEX fki_lab_obs_req_pat
    ON lab_obs_request
    USING btree
    (patient_id);

-- Index: fki_lab_obs_req_com

CREATE INDEX fki_lab_obs_req_com
  ON lab_obs_request
  USING btree
  (company_id);


-- Index: idx_lab_obs_req_grp

CREATE INDEX idx_lab_obs_req_gid
    ON lab_obs_request
    USING btree
    (groupid);
