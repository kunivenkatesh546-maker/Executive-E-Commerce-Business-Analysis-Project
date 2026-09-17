SELECT
  items.item_name,
  COUNT(*) AS purchased
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
UNNEST(items) AS items
WHERE event_name = 'purchase'
GROUP BY items.item_name
ORDER BY purchased DESC
LIMIT 10;