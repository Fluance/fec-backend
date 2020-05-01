CREATE TABLE capacity
(
  company_id integer NOT NULL,
  roomnumber varchar(255) NOT NULL,
  unit varchar(255),
  service varchar(255),
  financialclass varchar(255),
  nbbed integer,
  CONSTRAINT capacity_pkey PRIMARY KEY (company_id, roomnumber),
  CONSTRAINT fk_cap_com FOREIGN KEY (company_id)
      REFERENCES company (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

ALTER TABLE capacity
  OWNER TO fluance;
