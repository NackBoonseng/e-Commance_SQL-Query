SELECT 
    pageview_url, 
    COUNT(DISTINCT website_pageview_id) AS Session
FROM
    website_pageviews
WHERE
    created_at < '2012-06-09'
GROUP BY 1
ORDER BY 2 DESC
;

/* The result shows that Home page is main priority for the website manager to ensure that they keep up to date and perform well*/

