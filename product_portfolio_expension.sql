-- Business Requirement:the business has launched the third product targeting the birthday gigt (Birthday Bear)
	-- SO, they want to know a pre-pose analysis comparing the month before vs. the month after interms of session order, conversion rate average of value and product per order
    -- date: 2013-12-12 -- tarhet month before < 2013-12-12 and month after >= 2013-12-12
    
    
    

select 
	case 
		when s.created_at < '2013-12-12' then 'A. Pre_Birthday_Bear'
        when s.created_at >= '2013-12-12' then 'B. Post_Birthday_Bear'
        else 'Check_the_logic'
        end as time_period,
	count(distinct s.website_session_id) as session,
    count(distinct o.order_id) as orders,
    count(distinct o.order_id)/
		count(distinct s.website_session_id) as conversion_rate, -- website_session_id that turn into order
	sum(o.price_usd) as Total_Revenue,
    sum(o.items_purchased) as items_purchased_sold,
    sum(o.price_usd)/
		count(distinct o.order_id) as average_order_value, -- based on individual order price/order_id
	sum(o.items_purchased)/
		count(distinct o.order_id) as product_per_order, -- item_purchased/order how many product sold per order
	sum(o.price_usd)/
		count(distinct s.website_session_id) as revenue_per_session -- price/session_id to see the price for that session_id
from website_sessions s
	left join orders o
    on s.website_session_id = o.website_session_id
where s.created_at between '2013-11-12' and '2014-01-12'
group by 1
;
    
    
-- Result: evething look fantastic after launching the theird product as it terned out postitive impact
    
    
    