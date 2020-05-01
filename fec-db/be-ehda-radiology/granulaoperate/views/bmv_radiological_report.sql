-- View: bmv_radiological_report

CREATE OR REPLACE VIEW bmv_radiological_report AS
SELECT * FROM (
 SELECT r.studyuid,
	r.patient_id,
	r.company_id,
	r.ordernb,
	r.studydt,
	r.report,
	r.completion,
	r.verification,
	r.referringphysician,
	r.recordphysician,
	r.performingphysician,
	r.readingphysician,
	rank() OVER (PARTITION BY ordernb, company_id ORDER BY studyuid DESC) AS rank
 FROM radiological_report r
) sub;

ALTER TABLE bmv_radiological_report
  OWNER TO fluance;
