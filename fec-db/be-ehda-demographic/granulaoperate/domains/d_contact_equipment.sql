-- Domain: contact_equipment

-- DROP DOMAIN contact_equipment;

CREATE DOMAIN contact_equipment
  AS character varying(20)
  COLLATE pg_catalog."default"
  NOT NULL
  CONSTRAINT contact_equipment_check CHECK (VALUE::text = ANY (ARRAY['beeper'::text, 'cellular_phone'::text, 'fax'::text, 'internet_address'::text, 'modem'::text, 'telephone'::text, 'satellite_phone'::text, 'telecom_dev_deaf'::text, 'teletypewriter'::text, 'x400_address'::text]));

ALTER DOMAIN contact_equipment
  OWNER TO fluance;
