/* Business Concept
Basesd on the business concept, maevn fuzzy factory is a web-base service, where customer will have a look their product on the website.
In order to data analysis, the website contains 3 main pages - Page A Page B and Page 3. In the business secerio, the most view is on
Page B, so that the business need to identify where to focus in improving the business.

-- Business common case study
1. Fiding the most-viewed page that customer view on the website
2. Identify the most common entry page ti the website- the first thing that a user see
3. For most-viewed page and most common entry page, understaind how thoese page perform for the business objecttives.

*/

-- Creating temporary table

/* Case secerio - Finding the tob pages
1. Analyse our pageview data and group by URl ti see which page are viewed ths most
2. To find top entry pages, we will limit to just the first page a user sees during a given session, using a temp
*/

/* Undertanding the data = website_sessions table has PK as website_session_id, user_id can be repeated as showing the number 
of users has returned to website (showing in column, is_repeat_session)

select * -- count(distinct website_session_id), count(distinct user_id)
from website_sessions
where user_id = '320543'
;
*/

SELECT 
    pageview_url,
    COUNT(DISTINCT website_pageview_id) AS pageview
FROM
    website_pageviews
WHERE
    website_pageview_id < 1000
GROUP BY 1
ORDER BY pageview DESC
;

----------------------------------------------------

Create temporary table first_pageview
SELECT 
    website_session_id,
    min(website_pageview_id) as min_pageview_id
FROM
    website_pageviews
WHERE
    website_pageview_id < 1000
group by 1
;



select 
	w.pageview_url as landing_page,-- aka'entry page'
    count(distinct f.website_session_id) as session_hiting_this_lander
from first_pageview f
left join website_pageviews w
	on f.min_pageview_id = w.website_pageview_id -- Understand min page view, where website_session_id is increment number so we identified the minimum pageview_id to find the first pageview
group by 1
;

/* Analysis result - the result shows that the business need to focus on Home Page, where the users mostly see*/
