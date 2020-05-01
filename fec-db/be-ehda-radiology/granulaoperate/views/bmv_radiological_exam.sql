-- View: bmv_radiological_exam

-- DROP VIEW bmv_radiological_exam;

CREATE OR REPLACE VIEW bmv_radiological_exam AS
 SELECT r.patient_id,
 r.ordernb,
 r.diagnosticservice,
 r.identifiercode,
 r.observation,
 r.observationdt,
 r.resulturl,
 r.company_id,
 c.name
 FROM radiological_exam r JOIN company c ON (r.company_id = c.id);

ALTER TABLE bmv_radiological_exam
  OWNER TO fluance;
