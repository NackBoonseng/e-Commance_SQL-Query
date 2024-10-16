-- Business Requirement: a comparison of conversion rate and revenue per session for repeat session s new session
	-- date 2014 onward to Nov 08, 2014
    
    
select 
	is_repeat_session,
    count(distinct s.website_session_id) as sessions,
    count(distinct o.order_id)
		/count(distinct s.website_session_id) as conversion_rate,
    sum(price_usd)
		/count(distinct s.website_session_id) as revenue_per_session
from website_sessions s
	left join orders o
    on s.website_session_id = o.website_session_id
where s.created_at < '2014-11-08'
	and s.created_at >= '2014-01-01'
group by 1
;