REFRESH MATERIALIZED VIEW CONCURRENTLY m_bmv_hospservice WITH DATA;
SELECT 'refreshed' AS m_bmv_hospservice;
REFRESH MATERIALIZED VIEW CONCURRENTLY m_bmv_patientunit WITH DATA;
SELECT 'refreshed' AS m_bmv_patientunit;
REFRESH MATERIALIZED VIEW CONCURRENTLY m_bmv_patientroom WITH DATA;
SELECT 'refreshed' AS m_bmv_patientroom;
REFRESH MATERIALIZED VIEW CONCURRENTLY m_bmv_patientbed WITH DATA;
SELECT 'refreshed' AS m_bmv_patientbed;
