
-- ============================================================
-- Root Cause Analysis: Identify the largest drop-off in the funnel
-- Business Question:
-- Where do users abandon the purchase journey?
-- ============================================================

WITH funnel AS (
    SELECT
        event_name,
        COUNT(DISTINCT user_pseudo_id) AS users
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE event_name IN (
        'page_view',
        'view_item',
        'add_to_cart',
        'begin_checkout',
        'add_shipping_info',
        'add_payment_info',
        'purchase'
    )
    GROUP BY event_name
),

ordered_funnel AS (
    SELECT
        event_name,
        users,
        CASE event_name
            WHEN 'page_view' THEN 1
            WHEN 'view_item' THEN 2
            WHEN 'add_to_cart' THEN 3
            WHEN 'begin_checkout' THEN 4
            WHEN 'add_shipping_info' THEN 5
            WHEN 'add_payment_info' THEN 6
            WHEN 'purchase' THEN 7
        END AS step_no
    FROM funnel
)

SELECT
    event_name,
    users,
    LAG(users) OVER(ORDER BY step_no) AS previous_step_users,

    ROUND(
        SAFE_DIVIDE(
            users,
            LAG(users) OVER(ORDER BY step_no)
        ) * 100,
        2
    ) AS conversion_from_previous_step,

    ROUND(
        100 -
        SAFE_DIVIDE(
            users,
            LAG(users) OVER(ORDER BY step_no)
        ) * 100,
        2
    ) AS drop_off_percentage

FROM ordered_funnel
ORDER BY step_no;