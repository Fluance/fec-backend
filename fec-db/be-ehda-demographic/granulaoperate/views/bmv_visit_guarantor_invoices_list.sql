/*
	View: bmv_visit_guarantor_invoices_list

	View used to provide a list of invoices for each guarantor declared in a visit

	See also:
		<m_bmv_invoice>
*/

CREATE OR REPLACE VIEW bmv_visit_guarantor_invoices_list AS
 SELECT id,
	invdt,
	total,
	balance,
	guarantor_id,
	visit_nb
 FROM m_bmv_invoice;

ALTER TABLE bmv_visit_guarantor_invoices_list
  OWNER TO fluance;
