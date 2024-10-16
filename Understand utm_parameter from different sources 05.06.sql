select w.utm_content, 
	count(distinct w.website_session_id) as Sessions, 
    count(distinct o.order_id) as Orders,
    count(distinct o.order_id)/count(distinct w.website_session_id) as Session_to_Conv_rt
from website_sessions w
	left join orders o
    on o.website_session_id = w.website_session_id
where w.website_session_id between 1000 and 2000
group by 1
order by 2 desc;