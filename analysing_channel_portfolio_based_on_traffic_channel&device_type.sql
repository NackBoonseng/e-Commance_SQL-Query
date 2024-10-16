-- Business requirement: bsearch, nonbrand on December 2nd
	-- Require: weekly session volumn for gsearch and bsearch nonbrand, broken down since November 4th
	-- include a comparison metric to show bsearch as percen of gsearch
    


select 
	-- yearweek(s.created_at) as year_week,
    min(date(s.created_at)) as week_start_date,
    count(distinct s.website_session_id) as session,
    count(distinct case when s.utm_source = 'gsearch'  and s.device_type = 'desktop' then s.website_session_id else null end) as gsearch_desktop__session,
	count(distinct case when s.utm_source = 'bsearch'  and s.device_type = 'desktop' then s.website_session_id else null end) as bsearch_desktop__session,
	count(distinct case when s.utm_source = 'bsearch'  and s.device_type = 'desktop' then s.website_session_id else null end)/
		count(distinct case when s.utm_source = 'gsearch'  and s.device_type = 'desktop' then s.website_session_id else null end) as bsearch_percent_of_gsearch,
    count(distinct case when s.utm_source = 'gsearch'  and s.device_type = 'mobile' then s.website_session_id else null end) as gsearch_mobile__session,
	count(distinct case when s.utm_source = 'bsearch'  and s.device_type = 'mobile' then s.website_session_id else null end) as bsearch_mobile__session,
	count(distinct case when s.utm_source = 'bsearch'  and s.device_type = 'mobile' then s.website_session_id else null end)/
		count(distinct case when s.utm_source = 'gsearch'  and s.device_type = 'mobile' then s.website_session_id else null end) as bsearch_percent_of_gsearch
from website_sessions s
where s.created_at > '2012-11-04'
	and s.created_at < '2012-12-22'
    and s.utm_campaign = 'nonbrand'
group by yearweek(s.created_at)
;


-- Result: as the trend "bseach" was dropped off a bit started on '2012-12-02', which is after Feburary 
	-- and gsearch was down after BlackFriday and Monday(Major Online Holidays)  -- see the seasonality 