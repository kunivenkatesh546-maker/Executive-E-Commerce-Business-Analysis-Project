SELECT
    traffic_source.source AS source,
    COUNT(DISTINCT user_pseudo_id) AS unique_users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE traffic_source.source IS NOT NULL
GROUP BY source
ORDER BY unique_users DESC;