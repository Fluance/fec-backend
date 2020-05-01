-- Table: user_client_data

-- DROP TABLE user_client_data;

CREATE TABLE user_client_data
(
    profile_id integer NOT NULL,
    client_id UUID NOT NULL,
    preferences JSON NOT NULL,
    history JSON,
    CONSTRAINT user_client_data_pkey PRIMARY KEY (profile_id, client_id),
    CONSTRAINT fk_ucd_user FOREIGN KEY (profile_id)
        REFERENCES profile (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_ucd_client FOREIGN KEY (client_id)
        REFERENCES client (id) MATCH SIMPLE
        ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
  OIDS=FALSE
);
ALTER TABLE user_client_data
  OWNER TO wso2;
