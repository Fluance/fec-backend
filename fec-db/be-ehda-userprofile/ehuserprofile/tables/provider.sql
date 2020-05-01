-- Table: provider

-- DROP TABLE provider;

CREATE TABLE provider
(
    id serial NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    CONSTRAINT provider_pkey PRIMARY KEY (id),
    CONSTRAINT un_provider_name UNIQUE (name)
)
WITH (
    OIDS=FALSE
);

ALTER TABLE provider
    OWNER TO wso2;
