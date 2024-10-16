-- Business Requirement: 25 Sep, the business gave the option to customer to add 2 product on their cart 
	-- they need to know the comparison the month before** and the moth after** 
    -- and they want to know the conversion funnels rate fron cart_, avg product per order, aveage over value and pverall revenue per cart page view

-- step1: identify the relevant cart page view and their session
-- step2: see which of thoes cart session clicked through t the shipping page
-- step3: find the orders associated with the cart session, analye products purchased , average over values
-- step4: aggregate and analyze a summary of our findings


-- step1:

-- create temporary table session_seeing_carts
select 
	case
		when created_at < '2013-09-25' then 'A.Pre_Cross_Sell'
        when created_at >= '2013-01-06' then 'B. Post_Cross_Sell'
        else 'Check_the_Logic'
        end as time_period,
	website_session_id as cart_session_id,
    website_pageview_id as cart_pageview_id
from website_pageviews
where created_at between '2013-08-25' and '2013-10-25'
	and pageview_url = '/cart'
;



-- next:

-- create temporary table cart_sessions_seeing_another_page
select 
	s.time_period,
    s.cart_session_id,
    min(p.website_pageview_id) as pageview_id_after_cart
from session_seeing_carts s
	left join website_pageviews p
    on s.cart_session_id = p.website_session_id
    and p.website_pageview_id > s.cart_pageview_id -- only grabing pageview_id after the customer see the carts
group by 1, 2
having min(p.website_pageview_id) is not null
;


-- next:

-- create temporary table pre_post_session_orders
select 
	time_period,
    cart_session_id,
    order_id,
    items_purchased,
    price_usd
from session_seeing_carts s
	inner join orders o
    on s.cart_session_id = o.website_session_id
;


-- next:

select
	s.time_period,
    s.cart_session_id,
    case when c.cart_session_id is null then 0 else 1 end as clicked_to_another_page,
    case when p.order_id is null then 0 else 1 end as placed_order,
    p.items_purchased,
    p.price_usd
from session_seeing_carts s
	left join cart_sessions_seeing_another_page c
		on s.cart_session_id = c.cart_session_id
    left join pre_post_session_orders p
		on s.cart_session_id = p.cart_session_id
order by 
	1
;



select 
	time_period,
    count(distinct cart_session_id) as cart_session,
    sum(clicked_to_another_page) as clickthrough,
    sum(clicked_to_another_page)/
		 count(distinct cart_session_id) as cart_clickthrough,
	sum(placed_order) as orders_placed,
    sum(items_purchased) as products_purchased,
    sum(items_purchased)/
		sum(placed_order) as product_per_orders,
	sum(price_usd) as revenue,
    sum(price_usd)/
		sum(placed_order) as average_of_value,
	sum(price_usd)/
		count(distinct cart_session_id) as rev_per_cart_session
    
from (
select
	s.time_period,
    s.cart_session_id,
    case when c.cart_session_id is null then 0 else 1 end as clicked_to_another_page,
    case when p.order_id is null then 0 else 1 end as placed_order,
    p.items_purchased,
    p.price_usd
from session_seeing_carts s
	left join cart_sessions_seeing_another_page c
		on s.cart_session_id = c.cart_session_id
    left join pre_post_session_orders p
		on s.cart_session_id = p.cart_session_id
order by 
	1
) as full_data
group by time_period
;


-- Result: click throug did not go down, on the other hand, the rate was going up so that it's good for business for adding another products