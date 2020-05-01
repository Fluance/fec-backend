-- Table: lab_obs_request_note

-- DROP TABLE lab_obs_request_note;

CREATE TABLE lab_obs_request_note (
    id integer NOT NULL,
    lab_obs_req_ordernb character varying(255) NOT NULL,
    lab_obs_req_id integer NOT NULL,
    commentsrc character varying(255),
    comment text,
    CONSTRAINT lab_obs_request_note_pkey PRIMARY KEY (id, lab_obs_req_id, lab_obs_req_ordernb),
    CONSTRAINT fk_lab_obs_req_note_lab_obs_req FOREIGN KEY (lab_obs_req_id, lab_obs_req_ordernb)
        REFERENCES lab_obs_request (id, ordernb) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

-- Index: fki_lab_obs_req_note_lab_obs_req

-- DROP INDEX fki_lab_obs_req_note_lab_obs_req;

CREATE INDEX fki_lab_obs_req_note_lab_obs_req
    ON lab_obs_request_note
    USING btree
    (lab_obs_req_id, lab_obs_req_ordernb);



ALTER TABLE lab_obs_request_note
  OWNER TO fluance;
