/*select *
from website_sessions
;*/

SELECT 
    YEAR(created_at),
    WEEK(created_at),
    MIN(DATE(created_at)) AS week_start,
    COUNT(DISTINCT website_session_id) AS Sessions
FROM
    website_sessions
WHERE
    website_session_id BETWEEN 100000 AND 115000
GROUP BY 1 , 2
;