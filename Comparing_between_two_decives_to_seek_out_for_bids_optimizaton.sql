SELECT 
    COUNT(DISTINCT w.website_session_id) AS Count_session_id,
    COUNT(DISTINCT o.order_id) AS Count_order_id,
    concat(format(count(DISTINCT o.order_id) / COUNT(DISTINCT w.website_session_id)*100,2), '%') AS Conversasion_rate_to_order,
    w.device_type
FROM
    website_sessions w
        LEFT JOIN
    orders o ON o.website_session_id = w.website_session_id
WHERE
    w.created_at < '2012-05-11'
    and w.utm_source = 'gsearch'
    and w.utm_campaign = 'nonbrand'
GROUP BY 4
;

/* As expected, the desktop is performing well comparing to mobile, so the marketing team is ensure to bid on desktop*/


