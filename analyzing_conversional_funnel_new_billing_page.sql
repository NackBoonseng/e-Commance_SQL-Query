-- Business requirement after analysis conversion funnel: tested an updated billing page 
													-- 	comparision between /billing-2 and the orginal billing page
-- They want to know what percentage of session on thoes pages end up placing an order with all traffic


-- first, start by finding the starting point of frame analysis:

select 
	min(website_pageview_id) as min_pageview_id
from website_pageviews
where pageview_url = '/billing-2'
; -- first_pageview_id = 53550


-- Next: we'll look at without orders, then we will add orders 


select 
	p.website_session_id,
    p.pageview_url as billing_version_seen,
    o.order_id
from website_pageviews p
left join orders o
	on p.website_session_id = o.website_session_id
where p.website_pageview_id >= 53550 -- the min_pageview_id where the billing started live
	and p.created_at < '2012-11-10' -- Business requirement timeframe
    and p.pageview_url in ('/billing', '/billing-2')
;


-- Next: we then will be wrapping up as a subquery and summerizing
-- To perfrom our final analysis output


select 
	billing_version_seen,
    count(distinct website_session_id) as sessions,
    count(distinct order_id) as orders,
    count(distinct order_id)/count(distinct website_session_id) as billing_to_orders
from (
	select 
	p.website_session_id,
    p.pageview_url as billing_version_seen,
    o.order_id
from website_pageviews p
left join orders o
	on p.website_session_id = o.website_session_id
where p.website_pageview_id >= 53550 -- the min_pageview_id where the billing started live
	and p.created_at < '2012-11-10' -- Business requirement timeframe
    and p.pageview_url in ('/billing', '/billing-2')
    ) as billing_session_with_orders
group by
	billing_version_seen
;


-- The result: a new payment_page seems to be improved, it converts the customers willing to pay for the products 