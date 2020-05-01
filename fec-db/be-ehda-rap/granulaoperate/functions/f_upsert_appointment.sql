/*
    Function: upsert_appointment
        This function's goal is to update an already inserted appointment from rap. If it does not exist, insert it.

    Parameters:

        _cid - control id of the record
        _src - source application name

    Returns:
        None

    Algo:
        (start code)
        If (exists) THEN
            update appointment
	ELSE
	    insert appointment
        END IF
        (end code)

    See also:
        <appointment>, <insert_appointment>, <update_appointment>, <fdw_rap_sch_ais>
*/
CREATE FUNCTION upsert_appointment (_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $$

DECLARE
    v_aid INTEGER;
    v_compid INTEGER;

BEGIN
    IF (_cid <> '') IS NOT TRUE THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
    END IF;

    SELECT sch.sch_2_1, sch.company_id INTO v_aid, v_compid FROM fdw_rap_sch_ais(_cid) sch;

    -- Check if the appointment exists
    IF EXISTS (SELECT 1 FROM appointment a WHERE a.aid = v_aid AND a.company_id = v_compid) THEN
        PERFORM update_appointment(_cid, _src);
    ELSE
        PERFORM insert_appointment(_cid, _src);
    END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION upsert_appointment (VARCHAR, VARCHAR)
OWNER TO fluance;
