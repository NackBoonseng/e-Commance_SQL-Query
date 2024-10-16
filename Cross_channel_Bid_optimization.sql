-- Business requirement: nonbrand convension rate from session to order for gsearch and bsearch and slice the data
	-- by device type, start from 08-22 to 09-18 
    
    
select 
	s.device_type,
    s.utm_source,
    count( distinct s.website_session_id) as session,
    count( distinct o.order_id) as orders,
    count( distinct o.order_id)/count( distinct s.website_session_id) as conversion_rate
from website_sessions s
	left join orders o
    on s.website_session_id = o.website_session_id
where s.created_at > '2012-08-22'
	and s.created_at < '2012-09-19'
	and s.utm_campaign = 'nonbrand'
group by 1, 2
;


-- Result: gsearch on desktop is more likely to perform a good conversion rate as well as gsearch on mobile 