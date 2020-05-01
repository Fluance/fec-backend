-- Table: lab_obs_result_note

-- DROP TABLE lab_obs_result_note;

CREATE TABLE lab_obs_result_note (
    id integer NOT NULL,
    lab_obs_res_id integer NOT NULL,
    lab_obs_res_req_ordernb character varying (255) NOT NULL,
    lab_obs_res_req_id integer NOT NULL,
    commentsrc character varying (255),
    comment text,
    CONSTRAINT lab_obs_result_note_id_pkey PRIMARY KEY (id, lab_obs_res_id, lab_obs_res_req_ordernb, lab_obs_res_req_id),
    CONSTRAINT fk_lab_obs_res_note_lab_obs_res FOREIGN KEY (lab_obs_res_id, lab_obs_res_req_ordernb, lab_obs_res_req_id)
        REFERENCES lab_obs_result (id, lab_obs_req_ordernb, lab_obs_req_id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

ALTER TABLE lab_obs_result_note
OWNER TO fluance;

-- Index: fki_lab_obs_result_lab_obs_req_id

-- DROP INDEX fki_lab_obs_result_lab_obs_req_id;

CREATE INDEX fki_lab_obs_note_lab_obs_res
    ON lab_obs_result_note
    USING btree
    (lab_obs_res_id, lab_obs_res_req_ordernb, lab_obs_res_req_id);
