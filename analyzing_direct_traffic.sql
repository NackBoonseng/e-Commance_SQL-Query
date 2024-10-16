-- Business requirement: a potential nvestor asking if we're building up momentum with our brand or
	-- we need to continue on paid traffic
    -- Requirement: pull organic search, direct type in and paid brand seach session by month that show those session as % of paid search nonbrand
    
    
select distinct 
	s.utm_source,
    s.utm_campaign,
    s.http_referer
from website_sessions s
where s.created_at < '2012-12-23'
;

-- Next:
select distinct 
	case
		when s.utm_source is null and http_referer in ('https://www.gsearch.com', 'https://www.bsearch.com') then 'organic_search'
        when s.utm_campaign = 'nonbrand' then 'paid_nonbrand'
        when s.utm_campaign ='brand' then 'paid_brand'
		when s.utm_source is null and http_referer is null then 'direct_type_in'
        end as channel_group,
	s.utm_source,
    s.utm_campaign,
    s.http_referer
from website_sessions s
where s.created_at < '2012-12-23'
;

-- Next:

select 
	s.website_session_id,
    s.created_at,
	case
		when s.utm_source is null and http_referer in ('https://www.gsearch.com', 'https://www.bsearch.com') then 'organic_search'
        when s.utm_campaign = 'nonbrand' then 'paid_nonbrand'
        when s.utm_campaign ='brand' then 'paid_brand'
		when s.utm_source is null and http_referer is null then 'direct_type_in'
        end as channel_group
from website_sessions s
where s.created_at < '2012-12-23'
;


-- Next:


select 
	year(created_at) as year,
    month(created_at) as month,
    count(distinct case when channel_group = 'paid_nonbrand' then website_session_id else null end) as nonbrand,
    count(distinct case when channel_group = 'paid_brand' then website_session_id else null end) as brand,
		count(distinct case when channel_group = 'paid_brand' then website_session_id else null end)/
        count(distinct case when channel_group = 'paid_nonbrand' then website_session_id else null end) as brand_percentage_of_nonbrand,
	count(distinct case when channel_group = 'direct_type_in' then website_session_id else null end) as direct,
		count(distinct case when channel_group = 'direct_type_in' then website_session_id else null end)/
        count(distinct case when channel_group = 'paid_nonbrand' then website_session_id else null end) as direct_percentage_of_nonbrand,
	count(distinct case when channel_group = 'organic_search' then website_session_id else null end) as organic,
		count(distinct case when channel_group = 'organic_search' then website_session_id else null end)/
        count(distinct case when channel_group = 'paid_nonbrand' then website_session_id else null end) as organic_percentage_of_nonbrand
from (
	select 
    website_session_id,
    created_at,
	case
		when s.utm_source is null and http_referer in ('https://www.gsearch.com', 'https://www.bsearch.com') then 'organic_search'
        when s.utm_campaign = 'nonbrand' then 'paid_nonbrand'
        when s.utm_campaign ='brand' then 'paid_brand'
		when s.utm_source is null and http_referer is null then 'direct_type_in'
        end as channel_group
from website_sessions s
where s.created_at < '2012-12-23'
) as session_with_channel_group
group by year(created_at), month(created_at)
;


-- Note: for marketing understanding 
	-- Brand = where the company bids on ads (advertisment - paid traffic) 
    -- non_brand = is paid traffic but for thoese search with similar name but not fully same ( "Maven analytic" = brand, "online sql" = non_brand)
    -- organic = from organic search (not ads) from a search engine
    -- direct = when users directly type in the brand (unpaid traffic)
