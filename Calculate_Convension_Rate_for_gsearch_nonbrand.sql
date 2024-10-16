SELECT 
    COUNT(DISTINCT w.website_session_id) AS Sessions,
    COUNT(DISTINCT o.order_id) AS Total_Orders,
    COUNT(DISTINCT o.order_id) / COUNT(DISTINCT w.website_session_id) AS Conversion_rate_session_to_order
FROM
    website_sessions w
        LEFT JOIN
    orders o ON o.website_session_id = w.website_session_id
WHERE
    w.created_at < '2012-04-14'
    and utm_source = 'gsearch'
    and utm_campaign = 'nonbrand'
ORDER BY 3 DESC
;


 /*select *
from orders
;*/