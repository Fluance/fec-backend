/*
	Materialized View: m_bmv_invoice

	Materialized view used to filter invoices to use only those which have total or balance <> 0.0

	See also:
		<invoice>
*/

CREATE MATERIALIZED VIEW m_bmv_invoice AS
  SELECT i.id,
	i.invdt,
	i.total,
	i.balance,
	i.apdrg_code,
	i.apdrg_descr,
	i.mdc_code,
	i.mdc_descr,
	vi.guarantor_id,
	vi.visit_nb,
	g.name,
	g.code
 FROM invoice i JOIN visit_invoice vi ON (i.id = vi.invoice_id) LEFT JOIN guarantor g ON (vi.guarantor_id = g.id)
 WHERE (i.total <> 0.00 OR i.balance <> 0.00) AND i.reversalnb IS NULL
 ORDER BY visit_nb, vi.guarantor_id, i.id;

ALTER TABLE m_bmv_invoice
  OWNER TO dbinput;

GRANT ALL ON TABLE m_bmv_invoice TO fluance;

CREATE UNIQUE INDEX un_m_bmv_invoice_id
  ON m_bmv_invoice
  USING btree
  (id);

CREATE INDEX idx_m_bmv_invoice_nb_gua
  ON m_bmv_invoice
  USING btree
  (visit_nb,guarantor_id);
