-- Business Requirements
	-- The board needs to see the performance after the business has operated for 8 months
    -- The company's growth, trend, etc.
    
    
-- Tasks:
	-- 1. Gsearch seems to be the biggest driver of the business, pull out monthly trends for gsearch session and orders so that 
		-- we can showcase the growth
   
   
select * from orders;



select
	-- s.website_session_id,
    month(s.created_at) as month_,
    count(distinct o.order_id) as total_orders
    -- o.items_purchased
from website_sessions s
	left join orders o
    on s.website_session_id = o.website_session_id
where s.utm_source = 'gsearch'
	and s.created_at < '2012-11-27'
	and o.order_id is not null
group by month(s.created_at)
order by month(s.created_at) 
;


	-- 2. Monthly trend for gsearch, now the business needs more investigation whether 'nonbrand and brand campaigns

select 
	*
from website_sessions s
where s.utm_source = 'gsearch'
	-- and s. utm_campaign in ('brand', 'nonbrand')
;

-- drop table if exists total_ordes_monthly;
-- create temporary table total_orders_monthly
select 
	s.website_session_id,
    month(s.created_at) as month_,
    count(distinct o.order_id) as total_orders
    -- s.utm_campaign
    -- o.items_purchased
from website_sessions s
	left join orders o
    on s.website_session_id = o.website_session_id
where s.utm_source = 'gsearch'
	-- and s. utm_campaign in ('brand', 'nonbrand')
	and o.order_id is not null
group by  s.website_session_id
order by month (s.created_at) 
;


-- Next, we will use temp table to seperate two campaign (nonbrand, brand)

select 
	-- s.website_session_id,
    month(s.created_at) as month_,
    count(distinct case when utm_campaign = 'brand' then s.website_session_id else null end) as brand_campaign,
    count(distinct case when utm_campaign = 'nonbrand' then s.website_session_id else null end) as nonbrand_campaign
    -- s.utm_campaign
    -- o.items_purchased
from total_orders_monthly t
	left join website_sessions s
    on t.website_session_id = s.website_session_id
where s.created_at < '2012-11-27'
group by month(s.created_at)
;

-- the result shows that brand_campaign as their target has rapidly grown up, so that it'sconsidered a good sight for improvement 


/* -- Next, we will use subquery to perform the trend analysis based on 'nonbrand' and'brand'


select 
	*
from (
select 
	-- s.website_session_id,
    month(s.created_at) as month_,
    -- count(distinct o.order_id) as total_orders,
    count(distinct case when utm_campaign = 'brand' then s.website_session_id else null end) as brand_campaign,
    count(distinct case when utm_campaign = 'nonbrand' then s.website_session_id else null end) as nonbrand_campaign
    -- o.items_purchased
from website_sessions s
	left join orders o
    on s.website_session_id = o.website_session_id
where s.utm_source = 'gsearch'
	-- and s. utm_campaign in ('brand', 'nonbrand')
	and o.order_id is not null
group by month(s.created_at), s.utm_campaign
order by month (s.created_at) 
) as total_orders_monthly_by_campaigns
;
*/


	-- 3. On gsearch, drive into nonbrand, and piull out monthly session and order split by devices type, so the business
		-- can see the traffic source 

select * from website_sessions;

--  temporary table Total_orders_by_months
select
	-- s.website_session_id,
    month(s.created_at) as month_,
    count(distinct o.order_id) as total_orders
    -- s.device_type
from website_sessions s
	left join orders o
    on s.website_session_id = o.website_session_id
where s.utm_source = 'gsearch'
	and s.utm_campaign = 'nonbrand'
	and o.order_id is not null
group by month(s.created_at)
-- order by month(s.created_at) 
;


-- Next, we will split the total orders by device

select 
	-- s.website_session_id,
    month(s.created_at) as month_,
    count(distinct case when s.device_type = 'mobile' then s.website_session_id else null end) as mobile,
    count(distinct case when s.device_type = 'desktop' then s.website_session_id else null end) as desktop
    -- s.utm_campaign
    -- o.items_purchased
from total_orders_monthly t
	left join website_sessions s
    on t.website_session_id = s.website_session_id
where s.created_at < '2012-11-27'
group by month(s.created_at)
;

	-- 4. Board member might be concerned about the large % of the traffic grom gsearch, we will need to pull out monthly trends 
		-- for gsearch, alongside monthly trend for each of our oterh chennels
        
-- Breaking down the task: 1. we need to know the number of users who login into the website to see the percentage
						-- 2. identify the number by month
                        -- 3. compare with other channels

select 
	count(distinct s.website_session_id) as number_of_session_login,
    s.utm_source
from website_sessions s
group by 2
;

-- drop table if exists session_id_by_month;
-- create temporary table session_id_by_months
select 
	s.website_session_id,
	month(s.created_at) as month_
from website_sessions s
group by 1
;

-- Next, will find out the monthly trend for other channels

select 
	s.month_,
	-- count(distinct s.website_session_id) as number_of_session_id,
    count(distinct case when w.utm_source = 'bsearch' then s.website_session_id else null end) as bsearch,
    count(distinct case when w.utm_source = 'gsearch' then s.website_session_id else null end) as gsearch,
    count(distinct case when w.utm_source is null and w.http_referer is not null then s.website_session_id else null end) as organic_search, -- aka this coming from the search engine but doesn't have page tracking
    count(distinct case when w.utm_source is null and  w.http_referer is null then s.website_session_id else null end) as direct_type
from session_id_by_months s
	left join website_sessions w
	on s.website_session_id = w.website_session_id
where w.created_at < '2012-11-27'
group by s.month_
;


-- 5. sessions to order conversion rate by month


select
	year(s.created_at) as year_,
    month(s.created_at) as month_,
    count(distinct s.website_session_id) as sessions,
    count(distinct o.order_id) as total_orders,
    count(distinct o.order_id)/count(distinct s.website_session_id) as conversion_rates
from website_sessions s
	left join orders o
    on s.website_session_id = o.website_session_id
where -- s.utm_source = 'gsearch'
	 s.created_at < '2012-11-27'
	-- and o.order_id is not null
group by 
	year(s.created_at),
	month(s.created_at)
-- order by month(s.created_at) 
;

-- The result: this show the improvment as it climbs up the number of conversion rate


	-- 6. For gsearch lander test, the business requires the revenue that test earned 
    -- we need to look at the increase in CVR fro the test( Jun 19 - Jul 28), and use nonbrand session and revenue 
	-- cince then to calculate increment values
    
    
    use mavenfuzzyfactory;
    
    select 
		min(website_pageview_id) as first_test_pageview
	from website_pageviews
    where pageview_url = '/lander-1'
    ; -- 23504
    
    
    -- Next, we will find the first page_view_id
    
    -- create temporary table first_test_pageview
    select 
		p.website_session_id,
        min(p.website_pageview_id) as min_pageview_id
	from website_pageviews p
		inner join website_sessions s
		on p.website_session_id = s.website_session_id
        and s.created_at < '2012-07-28'
        and p.website_pageview_id >= 23504
        and s.utm_source = 'gsearch'
        and s.utm_campaign = 'nonbrand'
	group by website_session_id
    ;
    
-- Next: we will bring in the landing page to each session, but we will restricting ti home or lander-1

-- create temporary table nonbrand_test_session_with_landing_pages
select 
	f.website_session_id,
    p.pageview_url as landing_page
from first_test_pageview f
left join website_pageviews p
	on f.min_pageview_id = p.website_pageview_id
where 
	p.pageview_url in ('/home', '/lander-1')
;

-- then, we will make a table to bring in orders

-- create temporary table nonbrand_test_session_with_orders
select 
	n.website_session_id,
    n.landing_page,
    o.order_id as order_id
from nonbrand_test_session_with_landing_pages n
left join orders o
	on n.website_session_id = o.website_session_id
;


-- to find, the different between conversion rates

select 
	landing_page,
    count(distinct website_session_id) as sessions,
    count(distinct order_id) as orders,
    count(distinct order_id)/count(distinct website_session_id) as conversion_rate
from nonbrand_test_session_with_orders
group by 1   
; -- 0.0318 home vs. 0.0406 lander-1
  -- 0.0087 additional orders per session !!


-- then, we will find the most recent pageview for gsearch nonbrand where the traffic was sent to /home

select 
	max(s.website_session_id) as most_recent_gsearch_nonbrand_home_pageview
from website_sessions s
left join website_pageviews p
	on s.website_session_id = p.website_session_id
where s.utm_source = 'gsearch'
	and s.utm_campaign = 'nonbrand'
	and p.pageview_url = '/home'
    and s.created_at < '2012-11-07'
;  -- max_website_session_id = 17145


select 
	count(website_session_id) as session_since_test
from website_sessions
where created_at < '2012-11-27'
	and website_session_id > 17145
    and utm_source = 'gsearch'
    and utm_campaign = 'nonbrand'
; -- 22,972 website_session since the test

-- 22,972 * 0.0087 incremental conversion = 202 incremental order since 7/29
-- roughly 4 months, so roughly 50 extra order per month


	-- 7. for the landing page test analysis previously, the business requires a full conversion funnel from each of the two
		-- pages yo orders, by using the period (Jun 19 - Jul 28)

-- drop table if exists session_level_made_it_flagged;
-- create temporary table session_level_made_it_flagged
select 
	website_session_id,
    max(home_page) as saw_home_page,
    max(custom_lander) as saw_custom_lander,
    max(products_page) as products_made_it,
    max(mr_fuzzy_page) as mr_fuzzy_page_made_it,
    max(cart_page) as cart_page_made_it,
    max(shipping_page) as shipping_page_made_it,
    max(billing_page) as billing_page_made_it,
    max(thank_you_page) as thank_you_page_made_it
from (
select 
	s.website_session_id,
    p.pageview_url,
    -- p.created_at as pageview_created_at,
    case when pageview_url = '/home' then 1 else 0 end as home_page,
    case when pageview_url = '/lander-1' then 1 else 0 end as custom_lander,
    case when pageview_url = '/products' then 1 else 0 end as products_page,
    case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mr_fuzzy_page,
    case when pageview_url = '/cart' then 1 else 0 end as cart_page,
    case when pageview_url = '/shipping' then 1 else 0 end as shipping_page,
    case when pageview_url = '/billing' then 1 else 0 end as billing_page,
    case when pageview_url = '/thank-you-for-your-order' then 1 else 0 end as thank_you_page
from website_sessions s
	left join website_pageviews p
    on s.website_session_id = p.website_session_id
where s.created_at > '2012-06-19'
	and s.created_at < '2012-07-28' 
    and s.utm_campaign = 'nonbrand'
	and s.utm_source = 'gsearch'
) as session_level
group by website_session_id
;



-- then, this would produce the final output, part 1

select 
	case 
		when saw_home_page = 1 then 'saw_home_page'
        when saw_custom_lander = 1 then 'saw_custom_lander'
        else 'check_logic'
	end as segment,
    count(distinct website_session_id) as sessions,
    count(distinct case when products_made_it = 1 then website_session_id else null end) as to_products,
    count(distinct case when mr_fuzzy_page_made_it = 1 then website_session_id else null end) as to_mr_fuzzy,
    count(distinct case when cart_page_made_it = 1 then website_session_id else null end) as to_cart_page,
    count(distinct case when shipping_page_made_it = 1 then website_session_id else null end) as to_shipping,
    count(distinct case when billing_page_made_it = 1 then website_session_id else null end) as to_billing,
    count(distinct case when thank_you_page_made_it = 1 then website_session_id else null end) as to_thankyou
from session_level_made_it_flagged
group by 1
;


-- then, we will provide final output as click rates (Part 2)

select 
	case 
		when saw_home_page = 1 then 'saw_home_page'
        when saw_custom_lander = 1 then 'saw_custom_lander'
        else 'check_logic'
	end as segment,
    count(distinct case when products_made_it = 1 then website_session_id else null end)/count(distinct website_session_id) as lander_click_rate,
    count(distinct case when mr_fuzzy_page_made_it = 1 then website_session_id else null end)/count(distinct case when products_made_it = 1 then website_session_id else null end) as products_click_rate,
    count(distinct case when cart_page_made_it = 1 then website_session_id else null end)/count(distinct case when mr_fuzzy_page_made_it = 1 then website_session_id else null end) mr_fuzzy_click_rate,
    count(distinct case when shipping_page_made_it = 1 then website_session_id else null end)/count(distinct case when cart_page_made_it = 1 then website_session_id else null end) as cart_click_rate,
    count(distinct case when billing_page_made_it = 1 then website_session_id else null end)/count(distinct case when shipping_page_made_it = 1 then website_session_id else null end) as shipping_click_rate,
    count(distinct case when thank_you_page_made_it = 1 then website_session_id else null end)/count(distinct case when billing_page_made_it = 1 then website_session_id else null end) as billing_click_rate
from session_level_made_it_flagged
group by 1
;


	-- 8. quantity for the impact of the billing test by analyzing the lift generated from the test (Sep 10 - Nov 10),
		-- in term of revenue per billing page session, and then pull the number of billing page session for the past month 
        -- to understand monthly impact
        
select 
	p.website_session_id,
    p.pageview_url as billing_version_seen,
    o.order_id,
    o.price_usd
from website_pageviews p
	left join orders o
    on p.website_session_id = o.website_session_id
where p.created_at > '2012-09-10' -- as the business requirement 
	and p.created_at < '2012-11-10' 
    and p.pageview_url in ('/billing','/billing-2')
;



-- then, we will use subquery to pull out the billing_version_seen and count the session_id, and finally we will find out the revenue

select 
	billing_version_seen,
    count(distinct website_session_id) as sessions, -- count the overall session_id
    sum(price_usd)/count(distinct website_session_id) as revenue_per_billing_page_seen -- find out the revenue by sum the price and then devide by the count of session_id
from (
select 
	p.website_session_id,
    p.pageview_url as billing_version_seen,
    o.order_id,
    o.price_usd
from website_pageviews p
	left join orders o
    on p.website_session_id = o.website_session_id
where p.created_at > '2012-09-10' -- as the business requirement 
	and p.created_at < '2012-11-10' 
    and p.pageview_url in ('/billing','/billing-2')
) as billing_pageview_and_order_data
group by 1
;

-- $22.83 revenue per billing page seen for the old version
-- $31.34 for the new version
-- LIFT from the existing version to the new billing page: $8.51 per billing page view


select 
	count(website_session_id) as billing_session_per_month
from website_pageviews
where website_pageviews.pageview_url in ('/billing','/billing-2')
	and created_at between '2012-10-27' and '2012-11-27' -- past month
;


-- 1193 billing session past month
-- LIFT: $8.51 per billing session
-- VALUE OF BILLING TEST: 10,160 over the past month (BY MULTIPY by the billing session and LIFT)

		
    
    

