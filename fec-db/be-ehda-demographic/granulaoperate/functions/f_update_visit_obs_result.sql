/*
	Function: update_visit_obs_result
	This function's goal is to update observations for a visit.
	This segment represents, for Opale, all the data we have for a newborn.

	Parameters:
		_vn  -  visit_nb.
		_cid - control_id of the hl7 data in inbound.
		_src - application source name.

	Returns:
		None

	See also:
		<visit>, <visit_obs_result>, <fdw_demographic_obx>
*/
CREATE FUNCTION update_visit_obs_result(_vn BIGINT, _cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $$

DECLARE
    v_obx RECORD;

BEGIN
    IF _vn IS NULL THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _vn');
    END IF;

    -- Check if visit number exists
    IF EXISTS (SELECT 1 FROM visit v WHERE v.nb = _vn) THEN

        -- Delete all previous data for this visit
        DELETE FROM visit_obs_result WHERE visit_nb = _vn;

        -- Add the new ones.
        FOR v_obx IN
            SELECT * FROM fdw_demographic_obx(_cid)
        LOOP
        INSERT INTO visit_obs_result (visit_nb, valuetype, identifier, value, unit, resultstatus, source, sourceid) VALUES
                                    (_vn, v_obx.obx_2_1, v_obx.obx_3_2, v_obx.obx_5_1, v_obx.obx_6_1, v_obx.obx_11_1, _src, v_obx.control_id);
        END LOOP;
    ELSE
        PERFORM raise_error('EXCEPTION', 'Nonexistent VISIT NUMBER: ' || _vn);
    END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION update_visit_obs_result(BIGINT, VARCHAR, VARCHAR)
OWNER TO fluance;
