-- Testing a new custom landing page(/lander-1) 
-- Requirement: find bounce rate between /lander-1 against /home 
			-- look at the time period where lander get traffic


-- Step1: finding the first instance of /lander-1 to set analysis timeframe
-- Step2: counting the number of user using /lander-1 page
-- Step3: summerizing total session and bounced session, by landing_page

use mavenfuzzyfactory;
select 
		min(w.created_at) as first_created_at,
		min(w.website_pageview_id) as first_website_pageview_id
    
from website_pageviews w
where created_at < '2012-07-28'
	and w.pageview_url = '/lander-1'
;

-- Result: the first /lander-1 is going live on 2012-06-19 & pageview_id = 23504

-- Step2:
-- drop table if exists bounce_session_for_lander;
-- create temporary table bounce_session_for_lander

-- drop table if exists first_pageview;
-- create temporary table first_pageview
select  wp.website_session_id,
		min(wp.website_pageview_id) as min_pageview_id		
from website_pageviews wp
inner join website_sessions ws
	on wp.website_session_id = ws.website_session_id
where ws.created_at <'2012-07-28' -- based on business requirement for analysis
	and wp.website_pageview_id > 23504
    and ws.utm_source = 'gsearch'
    and ws.utm_campaign = 'nonbrand'
group by 1
;

-- Check:
select * from first_pageview;

-- Step2:
-- drop table if exists session_with_lander_page;
create temporary table session_with_lander_page
select 
	f.website_session_id, -- Note: we need to know the user on the session when they are loggin in the website 
    w.pageview_url as landing_pageview_url
from first_pageview f
	left join website_pageviews w 
    on f.min_pageview_id = w.website_pageview_id
where w.pageview_url in ('/lander-1','/home')
;

-- Check:
select * from session_with_lander_page;


-- Step3:
-- drop table if exists bounce_session;
create temporary table bounce_session
select 
	s.website_session_id,
    s.landing_pageview_url,
    count(w.website_pageview_id) as count_of_page_views
from session_with_lander_page s
left join website_pageviews w
	on w.website_session_id = s.website_session_id
group by 1,2
having count(w.website_pageview_id) = 1
;


-- Check: 
select * from bounce_session;


-- Check the matching between website_session_id and bounced_session_session_id
select 
	s.landing_pageview_url,
    s.website_session_id,
    b. website_session_id as bounced_website_session_id
from session_with_lander_page s
left join bounce_session b -- Note: we need to join back on session_with_lander_page because we need to check the accuracy of user on website_session_id if joined table shows value (NULL) then it matches the statement 
	on s.website_session_id = b.website_session_id
;


-- Step4:

select 
	s.landing_pageview_url,
    count(distinct s.website_session_id) as session,
    count(distinct b.website_session_id) as bounced_session,
    count(distinct b.website_session_id)/count(distinct s.website_session_id) as bounced_rate
from session_with_lander_page s
left join bounce_session b -- Note: we need to join back on session_with_lander_page because we need to check the accuracy of user on website_session_id if joined table shows value (NULL) then it matches the statement 
	on s.website_session_id = b.website_session_id
group by 1
;


-- Result: that show a new customer (/lander-1) has a lower bounce rate > improvement 



