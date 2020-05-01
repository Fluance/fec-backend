-- View: bmv_visit_intervention_data

-- DROP VIEW bmv_visit_intervention_data;

CREATE OR REPLACE VIEW bmv_visit_intervention_data AS 
select visit_nb, data, type, rank, interventiondt from visit_intervention_healthcare vih
join visit v on vih.visit_nb=v.nb; 

ALTER TABLE bmv_visit_intervention_data
  OWNER TO fluance;
