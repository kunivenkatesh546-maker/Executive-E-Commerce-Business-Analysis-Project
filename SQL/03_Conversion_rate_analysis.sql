WITH funnel_counts AS (
  SELECT 
    event_name,
    COUNT(DISTINCT user_pseudo_id) AS Unique_User
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
)

SELECT 
  event_name,
  Unique_User,
  -- 1. Grab the user count from the previous step in the funnel
  LAG(Unique_User) OVER (ORDER BY Unique_User DESC) AS previous_step_user,
  
  -- 2. Calculate the drop-off conversion rate between adjacent steps
  ROUND(
    SAFE_DIVIDE(
      Unique_User, 
      LAG(Unique_User) OVER (ORDER BY Unique_User DESC)
    ) * 100, 
    2
  ) AS adjacent_conversion_rate_pct

FROM funnel_counts
ORDER BY Unique_User DESC;