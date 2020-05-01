/*
	Function: upsert_invoice
	This function's goal is to insert/update an invoice.

	Parameters:
		_cid - UUID control_id of the hl7 data in inbound.
		_src - VARCHAR application source name.

	Returns:
		None

	Algo:
		(start code)
		IF (vn) THEN
			IF !(invoice_id AND batchnb) THEN
				IF !(invoice_id) THEN
					INSERT INVOICE
				ELSE
					DELETE INVOICE/ VISIT_INVOICE
					INSERT INVOICE
				ENDIF
			ENDIF
		ENDIF
		(end code)

	See also:
		<invoice>, <visit_invoice>, <insert_invoice>, <fdw_demographic_dwo_inv>
*/
CREATE OR REPLACE FUNCTION upsert_invoice(_cid UUID, _src VARCHAR)
RETURNS VOID AS $$

DECLARE
    _inv RECORD;

BEGIN

    IF _cid IS NULL THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
    END IF;

    SELECT * INTO _inv FROM fdw_demographic_dwo_inv(_cid);

    IF NOT FOUND THEN
        PERFORM raise_error('EXCEPTION', 'Record not found in granulainbound, UUID: ' || _cid);
    END IF;

    -- Check if visit number exists
    IF EXISTS (SELECT 1 FROM visit v WHERE v.nb = _inv.nb) THEN
        -- Don't process invoices with the same batchnb
	IF NOT EXISTS (SELECT 1 FROM invoice WHERE id = (_inv.invid::TEXT || _inv.sequencenb::TEXT)::BIGINT AND batchnb = _inv.batchnb) THEN
		-- Check if the invoice already exists
		IF NOT EXISTS (SELECT 1 FROM invoice WHERE id = (_inv.invid::TEXT || _inv.sequencenb::TEXT)::BIGINT ) THEN
		    PERFORM insert_invoice(_cid, _src);
		ELSE
		    -- Delete than insert
		    DELETE FROM invoice WHERE id = (_inv.invid::TEXT || _inv.sequencenb::TEXT)::BIGINT;
            
		    PERFORM insert_invoice(_cid, _src);
		END IF;
	END IF;
    ELSE
        PERFORM raise_error('EXCEPTION', 'Nonexistent VISIT NUMBER ' || _inv.nb || ' WITH PATIENT ID ' || _inv.pid);
    END IF;
END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION upsert_invoice(UUID, VARCHAR)
  OWNER TO fluance;
