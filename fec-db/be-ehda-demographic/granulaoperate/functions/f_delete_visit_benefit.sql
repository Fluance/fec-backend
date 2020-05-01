/*
	Function: delete_visit_benefit

	This function's goal is to delete a medical benefit associated to a visit in operate database.
	This function is called by Mirth in the channel P_DEMOGRAPHIC_EXP10_BENEFITS when a mutecode 03 is received in export10 message.

	Parameters:
		_rid - UUID row id of the HL7 messages in inbound database

	Returns:
		None

	Algo:
		(start code)
		IF (v_id) THEN
			DELETE visit_benefit(id) 
			-- visit_benefit_physician is also deleted by cascade.
		END IF
		(end code)

	See also:
		<visit_benefit>, <fdw_demographic_benefit>
*/
CREATE OR REPLACE FUNCTION delete_visit_benefit(_rid UUID)
RETURNS VOID AS $$

DECLARE
	v_ben RECORD;
	v_id BIGINT;

BEGIN

    IF _rid IS NULL THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _rid');
    END IF;

    SELECT * INTO v_ben FROM fdw_demographic_benefit(_rid);
    
    IF NOT FOUND THEN
        PERFORM raise_error('EXCEPTION', 'Record not found in granulainbound for UUID: ' || _rid);
    END IF;

    SELECT id INTO v_id FROM visit_benefit vb WHERE vb.visit_nb = v_ben.visit_nb AND vb.internalnb = v_ben.internalnb AND vb.sequencenb = v_ben.sequencenb;

    IF FOUND THEN
	-- Delete visit benefit
	DELETE FROM visit_benefit WHERE id = v_id;
    END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION delete_visit_benefit(UUID)
  OWNER TO fluance;
