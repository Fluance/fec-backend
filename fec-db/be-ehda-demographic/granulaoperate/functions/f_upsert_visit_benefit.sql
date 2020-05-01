/*
    Function: upsert_visit_benefit
        This function's goal is to update an already inserted visit benefit. If it does not exist, insert it.

    Parameters:

        _rid - UUID row id of the HL7 messages in inbound database
        _src - source application name

    Returns:
        None

    Algo:
        (start code)
        If (exists) THEN
            update visit benefit
	ELSE
	    insert visit benefit
        END IF
        (end code)

    See also:
        <visit_benefit>, <insert_visit_benefit_physician>, <fdw_demographic_benefit>
*/
CREATE FUNCTION upsert_visit_benefit (_rid UUID, _src VARCHAR(50))
RETURNS VOID AS $$

DECLARE
    v_visit_nb BIGINT;
    v_intnb INTEGER;
    v_seqnb INTEGER;

BEGIN
    IF _rid IS NULL THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _rid');
    END IF;

    SELECT fob.visit_nb, fob.internalnb, fob.sequencenb INTO v_visit_nb, v_intnb, v_seqnb FROM fdw_demographic_benefit(_rid) fob;

    -- Check if the visit benefit exists
    IF EXISTS (SELECT 1 FROM visit_benefit vb WHERE vb.visit_nb = v_visit_nb AND vb.internalnb = v_intnb AND vb.sequencenb = v_seqnb) THEN
        PERFORM update_visit_benefit(_rid, _src);
    ELSE
        PERFORM insert_visit_benefit(_rid, _src);
    END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION upsert_visit_benefit (UUID, VARCHAR)
OWNER TO fluance;
