SELECT 
    w.utm_source,
    w.utm_campaign,
    w.http_referer,
    COUNT(DISTINCT w.website_session_id) AS Sessions
FROM
    website_sessions w
WHERE
    w.created_at < '2012-04-12'
GROUP BY 1 , 2 , 3
ORDER BY 4 DESC
;

select *
from website_pageviews;
