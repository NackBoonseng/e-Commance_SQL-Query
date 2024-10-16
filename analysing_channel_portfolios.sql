-- Business requirement: the marketing team has launced a second paid search channels, "bsearch" in 07-22
-- They want to know the comparison from "gsearch" and "bsearch" - nonbrand in weeklu trended session volumn


use mavenfuzzyfactory;
select 
	-- yearweek(s.created_at) as year_week,
    min(date(s.created_at)) as week_start_date,
    count(distinct s.website_session_id) as total_session,
    count(distinct case when s.utm_source = 'gsearch' then s.website_session_id else null end) as gsearch_session,  
    count(distinct case when s.utm_source = 'bsearch' then s.website_session_id else null end) as bsearch_session 
from website_sessions s
where s.created_at > '2012-08-22' 
	and s.created_at < '2012-11-29'
	and s.utm_campaign = 'nonbrand'
group by yearweek(s.created_at)
;

-- Result: bsearch is big enough for further analysis and that we can see gsearch is 3 time double up bsearch consistantly 



