/*
	View: bmv_guarantor_contacts_list

	View used to provide the full contacts list of a guarantor

	See also:
		<guarantor>, <guarantor_contact>
*/

CREATE OR REPLACE VIEW bmv_guarantor_contacts_list AS
 SELECT c.nbtype,
	c.equipment,
	c.data,
	g.id
 FROM guarantor g JOIN guarantor_contact gc ON (g.id = gc.guarantor_id) JOIN contact c ON (gc.contact_id = c.id);

ALTER TABLE bmv_guarantor_contacts_list
  OWNER TO fluance;