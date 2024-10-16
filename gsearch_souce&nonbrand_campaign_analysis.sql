SELECT 
    MIN(date(created_at)) AS Start_Week_at,
    COUNT(DISTINCT website_session_id) AS Session
FROM
    website_sessions
WHERE
    created_at < '2012-05-12'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY YEAR(created_at) , WEEK(created_at)
;

/* Based on this analysis, the result shows that the source = gsearch on the campaign = nonbrand is decreasing the volumn 
for further analysis, the marketing team might need to consider whether this source&campaign need to be considered to get the vloumn back*/