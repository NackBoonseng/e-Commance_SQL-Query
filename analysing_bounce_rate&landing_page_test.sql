-- Business conecpt: landing page performance & testing = understanding the performance of the key landing page to improve result


/* Case study:  Page A > 70% > Cart >> compeleted order 30%
				Page B > 85% > cart >> compeleted order 9%
                
Common use case:
1. identify the top opportunities for landing pages - high volumn pages with higher than expectation bouce rates or low conversion rate
2. setting A/B exp on live traffic to see if the business can improve the bouce rate and conversion rate 
3. analyzing test result and making reccomendation on which version the business should use going forward
*/


-- Business context: we want to see landing page performance for a certain time period 

-- step1: find the first website_pageview_id for relevant sessions
-- step2: identify the landing page of each session
-- step3: counting pageview for each session, to identify "bounces"
-- step4: summeriing total session and bounced session, by LP

-- findinding the min website pageview_id associated with each session we care about 

create temporary table first_pageview_demo
SELECT 
    p.website_session_id,
    min(p.website_pageview_id) as min_pageview_id
FROM
    website_pageviews p
        INNER JOIN website_sessions s 
				ON p.website_session_id = s.website_session_id
				AND s.created_at BETWEEN '2014-01-01' AND '2014-02-01' -- arbitrary
group by 1
;

-- check the result of temp table

select *
from first_pageview_demo
;

-- next: we'll bring in the ladning page to each session

create temporary table session_website_landing_page_demo
SELECT 
    f.website_session_id,
    p.pageview_url as landing_page
FROM
    first_pageview_demo f
        LEFT JOIN website_pageviews p 
        ON f.min_pageview_id = p.website_pageview_id -- website_pageview is the landing pageview
;

-- check session_website_landing_page_demo result

select *
from session_website_landing_page_demo
;

-- next: we make a table to include a count of pageview per session (how many user are usig pageview on the particular session)

-- first, create a bounce session, where the user see the first landing page and sign out

create temporary table bounced_session_only
select 
	s.website_session_id,
    s.landing_page,
    -- w.website_pageview_id -- manually counting the number of pageview_id 
    count(w.website_pageview_id) as count_of_page_viewed
from session_website_landing_page_demo s
	left join website_pageviews w
	on w.website_session_id = s.website_session_id
group by 1,2
having count(w.website_pageview_id) = 1
;


-- Check bounced_session_only result = refer to business requirement where the analysis show which pageview_url, user only log in 1 time

select *
from bounced_session_only
;


-- next, we will summerise the analysis

select 
	s.landing_page,
    s.website_session_id,
    b.website_session_id as bounced_website_session_id
from session_website_landing_page_demo s
	left join bounced_session_only b
	on b.website_session_id = s.website_session_id
order by 2
;


-- final output, we will count the pageview (pageview_url at the beginning) for all session and group by landing page

select 
	s.landing_page,
    count(distinct s.website_session_id) as sessions,
    count(distinct b.website_session_id) as bounced_session,
    count(distinct b.website_session_id)/count(distinct s.website_session_id) as bounce_rate
from session_website_landing_page_demo s
	left join bounced_session_only b
	on b.website_session_id = s.website_session_id
group by 1
;

-- Result: the analysis shows that it could potentially be considered the result based on this analysis however, the bounce rate might not be 100% accurate becuase landing pages could be part of another pages so they may be connected 
