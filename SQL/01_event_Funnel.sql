create database Business_case_study;
use Business_case_study;
SELECT
  event_name,
  COUNT(*) AS total_events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY event_name
ORDER BY total_events DESC;