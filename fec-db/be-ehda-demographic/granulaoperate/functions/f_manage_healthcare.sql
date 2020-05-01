/*
	Function: manage_healthcare
	
	This function is used to insert healthcare information from granulainbound in the suitable table

	Parameters:
		_vn  - visit number.
		_cid - control id of the record.
		_src - source application name.

	Returns:
		None

	Algo:
		(start code)
		if exists
			DELETE visit_healthcare
			DELETE visit_intervention_healthcare
		endif
		for each pv2 segment
			if scope = visit
				INSERT visit_healthcare
			elseif scope = intervention
				INSERT visit_intervention_healthcare
			endif
		end foreach
		(end code)

	See also:
		 <visit>, <visit_healthcare>, <visit_intervention_healthcare>
*/
CREATE FUNCTION manage_healthcare(_vn BIGINT, _cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $$

DECLARE
  ope RECORD;

BEGIN
    IF _vn IS NULL THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _vn');
    END IF;

    IF EXISTS (SELECT 1 FROM visit_healthcare v WHERE v.visit_nb = _vn) THEN
	DELETE FROM visit_healthcare v WHERE v.visit_nb = _vn;
    END IF;
	
    IF EXISTS (SELECT 1 FROM visit_intervention_healthcare v WHERE v.visit_nb = _vn) THEN
	DELETE FROM visit_intervention_healthcare v WHERE v.visit_nb = _vn;
    END IF;

    FOR ope IN
	SELECT * FROM fdw_demographic_pv2(_cid)
    LOOP
	IF (ope.scope = 'visit') THEN
		INSERT INTO visit_healthcare VALUES (_vn, ope.data, ope.type, ope.pos, _src, ope.control_id);
	ELSIF (ope.scope = 'intervention') THEN
		INSERT INTO visit_intervention_healthcare VALUES (_vn, ope.data, ope.type, ope.pos, _src, ope.control_id);
	END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION manage_healthcare(BIGINT, VARCHAR, VARCHAR)
OWNER TO fluance;
