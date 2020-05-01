-- Table: visit_invoice

-- DROP TABLE visit_invoice;

CREATE TABLE visit_invoice
(
  invoice_id bigint NOT NULL,
  visit_nb bigint NOT NULL,
  guarantor_id bigint,
  CONSTRAINT visit_invoice_pkey PRIMARY KEY (visit_nb, invoice_id),
  CONSTRAINT fk_vis_inv_gua FOREIGN KEY (guarantor_id)
      REFERENCES guarantor (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE RESTRICT,
  CONSTRAINT fk_vis_inv_inv FOREIGN KEY (invoice_id)
      REFERENCES invoice (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_vis_inv_vis FOREIGN KEY (visit_nb)
      REFERENCES visit (nb) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

ALTER TABLE visit_invoice
  OWNER TO fluance;

-- Index: fki_vis_inv_gua

CREATE INDEX fki_vis_inv_gua
  ON visit_invoice
  USING btree
  (guarantor_id);

-- Index: fki_vis_inv_inv

CREATE INDEX fki_vis_inv_inv
  ON visit_invoice
  USING btree
  (invoice_id);

-- Index: fki_vis_inv_vis

CREATE INDEX fki_vis_inv_vis
  ON visit_invoice
  USING btree
  (visit_nb);
