/*
	Function: insert_invoice

	This function's goal is to add invoices related to a visit from inbound to operate database.
	This function is called by upsert_invoice.

	Parameters:
		_cid - UUID control_id of the hl7 data in inbound.
		_src - VARCHAR application source name.

	Returns:
		None

	Algo:
		(start code)
		GET record from inbound
		FIND guarantor_id
		INSERT INVOICE / VISIT_INVOICE
		(end code)

	See also:
		<invoice>, <visit_invoice>, <fdw_demographic_dwo_inv>
*/
CREATE OR REPLACE FUNCTION insert_invoice(_cid UUID, _src VARCHAR)
RETURNS VOID AS $$

DECLARE
    _inv RECORD;
    _gua BIGINT;

BEGIN

    IF _cid IS NULL THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
    END IF;
    
    -- Get the invoice record in inbound
    SELECT * INTO _inv FROM fdw_demographic_dwo_inv(_cid);

    -- format the guarantor, null if none
    IF _inv.guarantor_code = '0' OR _inv.guarantor_code IS NULL THEN
        _gua := null;
    ELSE
        -- Check if the guarantor exists
        SELECT id INTO _gua FROM guarantor WHERE code = _inv.guarantor_code;

        IF NOT FOUND THEN
		-- Check if the occasional guarantor exists
		SELECT id INTO _gua FROM guarantor WHERE code = (_inv.nb::TEXT || _inv.priority::TEXT || _inv.subpriority::TEXT);

		IF NOT FOUND THEN
			PERFORM raise_error('EXCEPTION', 'Nonexistent GUARANTOR CODE: ' || _inv.guarantor_code);
		END IF;
        END IF;
    END IF;

    -- Insert
    INSERT INTO invoice VALUES ( (_inv.invid::TEXT || _inv.sequencenb::TEXT)::BIGINT, CASE WHEN _inv.reversalnb = 0 THEN NULL ELSE (_inv.reversalnb::TEXT ||  _inv.sequencenb::TEXT)::BIGINT END, _inv.invdt, _inv.total, _inv.balance, _inv.apdrg_code, _inv.apdrg_descr, _inv.mdc_code, _inv.mdc_descr, _inv.batchnb, _src, _inv.control_id);
    INSERT INTO visit_invoice VALUES ( (_inv.invid::TEXT || _inv.sequencenb::TEXT)::BIGINT, _inv.nb, _gua );

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION insert_invoice(UUID, VARCHAR)
  OWNER TO fluance;
