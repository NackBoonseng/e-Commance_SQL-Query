-- Business requirement: Trended weekly since June 1 for paid search nonbrand traffic landing on/home and /lander-1
						-- Pull out overall paid search bounce rate trended weekly
                        
-- Step0: finding the first website_pageview_id first relevent session (homepage)               
-- Step1: identify the pageview_url (landing pages) for non brand traffic 
-- Step2: counting pageview for each session, to identify "bounce" 
-- Step4: summerising by week 

-- Data Check:
select * from website_sessions
where utm_campaign = 'nonbrand'
	and created_at > '2012-06-01'
;



-- Step1:
-- drop table if exists session_with_count_lander_and_created_at;
create temporary table session_with_min_pageview_and_view_count
select 
    s.website_session_id,
    min(p.website_pageview_id) as first_pageview_id, 
    count(p.website_pageview_id) as count_pageview
from website_sessions s 
inner join website_pageviews p
	on p.website_session_id = s.website_session_id
where s.created_at > '2012-06-01'
	and s.created_at < '2012-08-31'
    and s.utm_source = 'gsearch'
    and s.utm_campaign = 'nonbrand'
group by 1
; 

select *from session_with_min_pageview_and_view_count;

-- Step2:
create temporary table _session_with_count_landing_page_and_created_at
select 
	s.website_session_id,
    s.first_pageview_id,
    s.count_pageview,
    w.pageview_url as landing_page,
    w.created_at as session_created_at
from session_with_min_pageview_and_view_count s
	left join website_pageviews w
on s.first_pageview_id = w.website_pageview_id;

-- Check:
select *from _session_with_count_landing_page_and_created_at where count_pageview = 1;

-- Final Step:
-- Doing analysis on bounce rate by week


select 
	-- yearweek(session_created_at) as year_week,
	min(date(session_created_at)) as week_start_date,
    -- count(distinct website_session_id) as total_session,
    -- count(distinct case when count_pageview = 1 then website_session_id else null end) as bounce_session,
    count(distinct case when count_pageview = 1 then website_session_id else null end)*1.0/count(distinct website_session_id) as bounce_rate,
    count(distinct case when landing_page ='/home' then website_session_id else null end) as home_session,
    count(distinct case when landing_page = '/lander-1' then website_session_id else null end ) as lander_session
    
from _session_with_count_landing_page_and_created_at
group by yearweek(session_created_at)
;

-- Result: That is remarkable improvment where we can see bounce_rate has been dropping down from the start at 2012-06-01 and drop to 0.5 and keep going!




