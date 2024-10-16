-- Calculating_Bounce_Rates

-- Step1: finding the first website_pageview_id first relevent session (homepage)
-- Step2: identifying the landing page of each session
-- Step3: counting pageview for each session, to identify "bounce"
-- Step4: summerising by counting total session and bounced session


-- Step1:

use mavenfuzzyfactory;
create temporary table first_pageview_id
select  website_session_id,
		min(website_pageview_id) as min_pageview_id		
from website_pageviews w
where created_at < '2012-06-14'
group by 1
;

-- drop temporary table if exists first_pageview_id;

create temporary table first_pageviews
select  website_session_id,
		min(website_pageview_id) as min_pageview_id		
from website_pageviews w
where created_at < '2012-06-14'
group by 1
;

-- Check 
select *from first_pageviews;

-- Step2:
-- This could created redundant so that we need to specify the landing_pageview_url " /home"

-- drop table if exists session_with_home_landing_page;
create temporary table session_with_home_landing_page
select 
	f.website_session_id,
    w.pageview_url as landing_pageview_url
from first_pageviews f
left join website_pageviews w 
		on w.website_pageview_id = f.min_pageview_id -- The reason is to join first_pageview_id = w.website_session_id because if we join f.website_session_id, it will create duplicate values 
where w.pageview_url = '/home'
;

-- Test: Join w.website_session_id = f.website_session_id, it create duplicate values so that we will not be able to identify the landing_pageview_url
/*select 
	
	f.website_session_id,
    w.website_pageview_id,
    w.pageview_url as landing_pageview_url
from first_pageview_id f
left join website_pageviews w 
		on w.website_session_id = f.website_session_id
where w.pageview_url = '/home' -- Result seems to be correct but it returned 11408 rows instead of 7790 rows
	 and w.created_at < '2012-06-14'  
;
*/

-- Check: 
select * from session_with_home_landing_page;


-- Step3:
-- drop table if exists bounced_sessions;
create temporary table bounced_sessions
select 
	s.website_session_id,
    s.landing_pageview_url,
    count(w.website_pageview_id) as count_of_page_views
from session_with_home_landing_page s
left join website_pageviews w
	on w.website_session_id = s.website_session_id
group by 
	s.website_session_id,
    s.landing_pageview_url
having count(w.website_pageview_id) = '1'
;

-- Check:
select *from bounced_sessions;


-- Next:

select 
	count(distinct s.website_session_id) as session,
    count(distinct b.website_session_id) as bounced_session,
    count(distinct b.website_session_id)/count(distinct s.website_session_id) as bounced_rate
from session_with_home_landing_page s
	left join bounced_sessions b
    on s.website_session_id = b.website_session_id
;

-- Summerise the result: bounce_rate seem to be pretty high, so that website manager need to set up a new experiment to see if the new page does better
