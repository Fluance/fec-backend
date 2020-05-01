/*
	Function: manage_visit_benefit_physician

	This function's goal is to add all the physician for a visit benefit.

	Parameters:
		_id - BIGINT visit_benefit id.
		_rid - UUID row id of the HL7 messages in inbound database
		_src - source application name

	Returns:
		None

	See also:
		<visit_benefit>, <visit_benefit_physician>, <fdw_demographic_benefit>
*/
CREATE OR REPLACE FUNCTION manage_visit_benefit_physician(_id BIGINT, _rid UUID, _src VARCHAR(50))
RETURNS VOID AS $$

DECLARE
  v_rec RECORD;

BEGIN

  -- Delete previous physician
  IF EXISTS(SELECT 1 FROM visit_benefit_physician WHERE visit_benefit_id = _id)
  THEN
	DELETE FROM visit_benefit_physician WHERE visit_benefit_id = _id;
  END IF;

  /*
   * Store physicians
   */
  FOR v_rec IN
    SELECT * FROM fdw_demographic_benefit(_rid) WHERE (operating_physician IS NOT NULL OR paid_physician IS NOT NULL OR lead_physician IS NOT NULL)
  LOOP
    INSERT INTO visit_benefit_physician VALUES (_id, v_rec.operating_physician, v_rec.paid_physician, v_rec.lead_physician, _src, _rid);
  END LOOP;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION manage_visit_benefit_physician(BIGINT, UUID, VARCHAR)
  OWNER TO fluance;
