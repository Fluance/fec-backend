-- View: bmv_appointment_detail

-- DROP VIEW bmv_appointment_detail;

CREATE OR REPLACE VIEW bmv_appointment_detail AS
SELECT a.id AS appointment_id, 
    a.begindt, 
    a.enddt, 
    a.duration, 
    a.description,
    a.appointkindcode,
    a.appointkinddescription, 
    CASE a.type
        WHEN 'G' THEN 'group'
        WHEN 'O' THEN 'operation'
        WHEN 'P' THEN 'patient'
        ELSE NULL
        END AS type,
    p.id AS patient_id, 
    p.lastname, 
    p.firstname, 
    p.maidenname, 
    p.birthdate, 
    v.nb, 
    v.patientunit, 
    v.patientroom, 
    v.hospservice, 
    v.company_id,
    rp.personnels, 
    rl.locations, 
    rd.devices
FROM appointment a
JOIN visit v ON a.visit_nb = v.nb
JOIN patient p ON v.patient_id = p.id
LEFT JOIN LATERAL (SELECT jsonb_agg(jsonb_build_object('name', rp.name, 'role', rp.role, 'staffid', rp.staffid, 'begindt', arp.begindt, 'enddt', arp.begindt + ((arp.duration || ' seconds'::text)::interval), 'occupationcode', arp.occupationcode) ORDER BY arp.begindt, arp.duration) AS personnels
           FROM appointment_resource_personnel arp JOIN resource_personnel rp ON (rp.id = arp.rp_id AND rp.company_id = v.company_id)
           WHERE arp.appoint_id = a.id) AS rp ON TRUE
LEFT JOIN LATERAL (SELECT jsonb_agg(jsonb_build_object('name', rl.name, 'type', rl.type, 'begindt', arl.begindt, 'enddt', arl.begindt + ((arl.duration || ' seconds'::text)::interval)) ORDER BY arl.begindt, arl.duration) AS locations
           FROM appointment_resource_location arl JOIN resource_location rl ON (rl.id = arl.rl_id AND rl.company_id = v.company_id)
           WHERE arl.appoint_id = a.id) AS rl ON TRUE
LEFT JOIN LATERAL (SELECT jsonb_agg(jsonb_build_object('name', rd.name, 'type', rd.type, 'begindt', ard.begindt, 'enddt', ard.begindt + ((ard.duration || ' seconds'::text)::interval)) ORDER BY ard.begindt, ard.duration) AS devices
           FROM appointment_resource_device ard JOIN resource_device rd ON (rd.id = ard.rd_id AND rd.company_id = v.company_id)
           WHERE ard.appoint_id = a.id) AS rd ON TRUE
WHERE a.status = 'Booked';

ALTER TABLE bmv_appointment_detail
  OWNER TO fluance;
