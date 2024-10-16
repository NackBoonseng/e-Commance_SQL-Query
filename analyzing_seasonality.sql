-- Business requirement: business want to have allok at 2012's monthly and weekly volume petterns
					-- pull session volume and orders volume
                    
 -- Year&Monthly Trend Analysis                   

select 
	year(s.created_at) as year,
	month(s.created_at) as monthly,
	-- week(s.created_at) as week,
    count( distinct s.website_session_id) as session,
    count( distinct o.order_id) as orders
from website_sessions s
	left join orders o
    on s.website_session_id = o.website_session_id
where s.created_at < '2013-01-01'
	-- and s.created_at < '2012-12-31'
group by year(s.created_at), month(s.created_at)-- , week(s.created_at)
;


-- Start_of_week analysis

select 
	week(s.created_at) as week,
    min(date(s.created_at)) as week_start,
    count( distinct s.website_session_id) as session,
    count( distinct o.order_id) as orders
from website_sessions s
	left join orders o
    on s.website_session_id = o.website_session_id
where s.created_at < '2013-01-01'
	-- and s.created_at < '2012-12-31'
group by week(s.created_at)
;
