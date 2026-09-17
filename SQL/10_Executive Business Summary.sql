-- ============================================================
-- Executive Business Summary
-- Business Question:
-- What are the key business KPIs leadership should review?
-- ============================================================

WITH users AS (
    SELECT COUNT(DISTINCT user_pseudo_id) AS total_users
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
),

purchases AS (
    SELECT COUNT(*) AS total_purchases
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE event_name = 'purchase'
),

top_device AS (
    SELECT
        device.category AS device,
        COUNT(DISTINCT user_pseudo_id) AS users
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    GROUP BY device
    ORDER BY users DESC
    LIMIT 1
),

top_source AS (
    SELECT
        traffic_source.source AS source,
        COUNT(DISTINCT user_pseudo_id) AS users
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE traffic_source.source IS NOT NULL
    GROUP BY source
    ORDER BY users DESC
    LIMIT 1
),

top_product AS (
    SELECT
        items.item_name,
        SUM(items.price_in_usd) AS revenue
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
    UNNEST(items) AS items
    WHERE event_name = 'purchase'
    GROUP BY items.item_name
    ORDER BY revenue DESC
    LIMIT 1
)

SELECT
    u.total_users,
    p.total_purchases,
    d.device AS top_device,
    s.source AS top_traffic_source,
    tp.item_name AS highest_revenue_product,
    ROUND(tp.revenue,2) AS revenue_generated

FROM users u
CROSS JOIN purchases p
CROSS JOIN top_device d
CROSS JOIN top_source s
CROSS JOIN top_product tp;