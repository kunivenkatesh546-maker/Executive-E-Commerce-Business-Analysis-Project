-- ============================================================
-- Advanced SQL Analysis: Product Revenue Ranking
-- Business Question:
-- Which products generate the highest revenue?
-- ============================================================

WITH product_revenue AS (

SELECT

items.item_name,

SUM(items.price_in_usd) AS total_revenue

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,

UNNEST(items) AS items

WHERE event_name='purchase'

GROUP BY items.item_name

)

SELECT

item_name,

ROUND(total_revenue,2) AS total_revenue,

RANK() OVER(ORDER BY total_revenue DESC) AS revenue_rank,

DENSE_RANK() OVER(ORDER BY total_revenue DESC) AS dense_rank,

ROW_NUMBER() OVER(ORDER BY total_revenue DESC) AS row_number

FROM product_revenue

ORDER BY total_revenue DESC;