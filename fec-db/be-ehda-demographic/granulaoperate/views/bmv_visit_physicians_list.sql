/*
	View: bmv_visit_physicians_list

	View used to provide a list of physicians involved in a visit

	See also:
		<visit_physician>, <bmv_physician_detail>
*/

CREATE OR REPLACE VIEW bmv_visit_physicians_list AS
SELECT attending.id AS attending_id,
       attending.firstname AS attending_firstname,
       attending.lastname AS attending_lastname,
       attending.staffid AS attending_staffid,
       referring.id AS referring_id,
       referring.firstname AS referring_firstname,
       referring.lastname AS referring_lastname,
       referring.staffid AS referring_staffid,
       consulting.id AS consulting_id,
       consulting.firstname AS consulting_firstname,
       consulting.lastname AS consulting_lastname,
       consulting.staffid AS consulting_staffid,
       admitting.id AS admitting_id,
       admitting.firstname AS admitting_firstname,
       admitting.lastname AS admitting_lastname,
       admitting.staffid AS admitting_staffid,
       visit_nb
FROM visit_physician vd 
	LEFT JOIN bmv_physician_detail attending ON attending.id = vd.attending_physician_id
	LEFT JOIN bmv_physician_detail referring ON referring.id = vd.referring_physician_id
	LEFT JOIN bmv_physician_detail consulting ON consulting.id = vd.consulting_physician_id
	LEFT JOIN bmv_physician_detail admitting ON admitting.id = vd.admitting_physician_id;

ALTER TABLE bmv_visit_physicians_list
  OWNER TO fluance;
