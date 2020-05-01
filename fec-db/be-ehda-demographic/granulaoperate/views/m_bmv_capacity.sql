/*
	Materialized View: m_bmv_capacity

	Materialized view used to filter capacity to use only those which have a number of beds <> 0

	See also:
		<capacity>
*/

CREATE MATERIALIZED VIEW m_bmv_capacity AS
  SELECT company_id,
	roomnumber,
	unit,
	service,
	financialclass,
	nbbed
  FROM capacity
  WHERE nbbed <> 0;

ALTER TABLE m_bmv_capacity
  OWNER TO dbinput;

GRANT ALL ON TABLE m_bmv_capacity TO fluance;

CREATE UNIQUE INDEX un_m_bmv_capacity_com_rom
  ON m_bmv_capacity
  USING btree
  (company_id, roomnumber);