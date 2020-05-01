/*
	View: bmv_physician_contacts_list

	View used to provide the full contacts list of a physician

	See also:
		<physician>, <physician_contact>
*/

CREATE OR REPLACE VIEW bmv_physician_contacts_list AS
 SELECT c.nbtype,
	c.equipment,
	c.data,
	p.id
 FROM physician p JOIN physician_contact pc ON (p.id = pc.physician_id) JOIN contact c ON (pc.contact_id = c.id);

ALTER TABLE bmv_physician_contacts_list
  OWNER TO fluance;
