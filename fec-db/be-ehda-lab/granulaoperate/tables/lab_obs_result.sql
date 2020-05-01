-- Table: lab_obs_result

-- DROP TABLE lab_obs_result;

CREATE TABLE lab_obs_result (
    id integer NOT NULL,
    lab_obs_req_ordernb character varying(255) NOT NULL,
    lab_obs_req_id bigint NOT NULL,
    valuetype character varying(255),
    analysiscode character varying(255),
    analysisname character varying(255),
    loinccode character varying(255),
    value text,
    unit character varying(255),
    refrange character varying(255),
    abnormalflag character varying(255),
    resultstatus character varying(255),
    source character varying(255),
    sourceid character varying(255),
    lastmodified timestamp without time zone,
    CONSTRAINT lab_obs_result_pkey PRIMARY KEY(id, lab_obs_req_ordernb, lab_obs_req_id),
    CONSTRAINT fk_lab_obs_res_lab_obs_req FOREIGN KEY (lab_obs_req_id, lab_obs_req_ordernb)
        REFERENCES lab_obs_request (id, ordernb) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE CASCADE
    )
    WITH
    (
        OIDS=FALSE
    );

ALTER TABLE lab_obs_result
    OWNER TO fluance;

-- Index: fki_lab_obs_result_lab_obs_req_id

-- DROP INDEX fki_lab_obs_result_lab_obs_req_id;

CREATE INDEX fki_lab_obs_result_lab_obs_req_id
    ON lab_obs_result
    USING btree
    (lab_obs_req_id, lab_obs_req_ordernb);
