/*
	View: bmv_invoice_detail

	View used to provide the full detail of an invoice

	See also:
		<m_bmv_invoice>
*/

CREATE OR REPLACE VIEW bmv_invoice_detail AS
 SELECT id,
    invdt,
    total,
    balance,
    apdrg_code,
    apdrg_descr,
    mdc_code,
    mdc_descr,
    name,
    code,
    guarantor_id,
    visit_nb
 FROM m_bmv_invoice;

ALTER TABLE bmv_invoice_detail
  OWNER TO fluance;
