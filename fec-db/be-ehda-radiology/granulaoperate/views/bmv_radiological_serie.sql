-- View: bmv_radiological_serie

CREATE OR REPLACE VIEW bmv_radiological_serie AS
SELECT r.serieiuid,
 r.patient_id,
 r.company_id,
 r.ordernb,
 r.orderobs,
 r.orderurl,
 r.diagnosticservice,
 mctd.description AS dsdesc,
 r.serieobs,
 r.serieobsdt
 FROM radiological_serie r
   LEFT JOIN m_cat_tel_dicom mctd ON (r.diagnosticservice = mctd.code)
 WHERE r.online = true;

ALTER TABLE bmv_radiological_serie
  OWNER TO fluance;
