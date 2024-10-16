-- Business Requirement: Comparison new vs repeat session by channel date: 2014 to Nov 05, 2014


-- create temporary table session_with_repeats
select
	new_sessions.user_id,
    new_sessions.website_session_id as new_session_id,
    -- new_sessions.created_at as new_session_created_at,
    website_sessions.website_session_id as repeat_session_id
    -- website_sessions.created_at as website_Session_created_at
from (
	select 
		user_id,
		website_session_id,
        created_at
	from website_sessions
	where created_at < '2014-11-05'
		and created_at >= '2014-01-01'
		and is_repeat_session = 0 -- this is new session only
	) as new_sessions
left join website_sessions
	on website_sessions.user_id = new_sessions.user_id
	and website_sessions.is_repeat_session = 1
    and website_sessions.website_session_id > new_sessions.website_session_id
    and website_sessions.created_at < '2014-11-05'
	and website_sessions.created_at >= '2014-01-01'
;

-- drop table if exists session_with_repeats;


select 
	s.utm_source as channel,
    s.utm_campaign,
    s.http_referer,
    count(distinct r.new_session_id) as new_sessions,
    count(distinct r.repeat_session_id) as repeat_session
from session_with_repeats r
	left join website_sessions s
    on r.user_id = s.user_id
where r.repeat_session_id is not null
group by 1, 2, 3
order by 5 desc
;


select * from website_sessions;

/*------------------------------------------------------------------------------*/

-- Better Output


select
	utm_source,
    utm_campaign,
    http_referer,
	count(distinct case when is_repeat_session = 0 then website_session_id else null end) as new_session,
    count(distinct case when is_repeat_session = 1 then website_session_id else null end) as repeat_session
from website_sessions
where 	created_at < '2014-11-05'
		and created_at >= '2014-01-01'
group by 1, 2, 3
order by 5 desc
;

-- Result: no source, campaign but has http is organic_search 
 -- then from brand, search engine
 
 
 select 
	case
		when utm_source is null and http_referer in ('https://www.gsearch.com', 'https://www.bsearch.com') then 'organic_search'
        when utm_campaign = 'nonbrand' then 'paid_nonbrand'
        when utm_campaign = 'brand' then 'paid_brand'
        when utm_source is null and http_referer is null then 'direct_type_it'
        when utm_source = 'socialbook' then 'paid_social'
        end as channel_group,
	count(distinct case when is_repeat_session = 0 then website_session_id else null end) as new_session,
	count(distinct case when is_repeat_session = 1 then website_session_id else null end) as repeat_session
from website_sessions
where  	created_at < '2014-11-05'
		and created_at >= '2014-01-01'
group by 1
order by 3 desc
;

-- Result: the highest number of repeat customer from organic search 



