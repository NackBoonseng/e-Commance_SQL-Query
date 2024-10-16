-- Business Requirement: the marketin gteam wants to know more about bsearch nonbrand
	-- they require the percentage of traffic coming on Mobile and compare to gsearch
    -- aggregate data since August 22nd 
    
    
-- Key approaches: 
				-- 1. we need to know the session_id, specifically "nonbrand" coming on "mobile"
                -- 2. 
    
select 
	 s.utm_source,
     count(distinct s.website_session_id) as session,
     count( distinct case when s.device_type = 'mobile' then s.website_session_id else null end) as mobile_session,
     count( distinct case when s.device_type = 'mobile' then s.website_session_id else null end)/
     count(distinct s.website_session_id) as percentage_mobile
from website_sessions s 
where s.created_at > '2012-08-22'
	and s.created_at < '2012-11-30'
    and s.utm_campaign = 'nonbrand'
group by 1
;


-- Result: what we can see is that the majority of gsearch on mobile is huge so that the business can continue improving on gsearch 