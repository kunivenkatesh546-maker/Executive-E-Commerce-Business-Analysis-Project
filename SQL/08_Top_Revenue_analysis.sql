SELECT
  items.item_name,
  SUM(items.price_in_usd) AS revenue
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
UNNEST(items) AS items
WHERE event_name = 'purchase'
GROUP BY items.item_name
ORDER BY revenue DESC
LIMIT 10;