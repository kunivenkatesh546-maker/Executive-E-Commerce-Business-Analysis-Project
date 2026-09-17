select 
    event_name,
    count(distinct user_pseudo_id) as Unique_User
from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
where event_name IN (
    'page_view',
    'view_item',
    'add_to_cart',
    'begin_checkout',
    'add_shipping_info',
    'add_payment_info',
    'purchase'
)
GROUP BY event_name
ORDER BY Unique_User DESC;