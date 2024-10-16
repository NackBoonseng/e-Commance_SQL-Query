-- Business requirement: understanding why the business lose the new lander-1 page and placeing an order
-- they need a full conversion funnel, analyzing how many customer make it in each step?
-- Point: start with lander-1 to thank-you_page since August 5 to Sep 5


-- Key approaches: 

-- Step1: select all pageviews for releant session
-- Step2: identify each relevent pageview as the specific funnel step
-- Step3: create the session_level conversion funnerl view
-- Step4: aggerate the data to assess funnel performance 


select * from website_sessions;
select * from website_pageviews 
where created_at between '2012-07-05' and '2012-09-05'
	and website_session_id = 13949 
;

-----------------------------------------------------------------------
-- Step1:

select 
	s.website_session_id,
    p.pageview_url,
    -- p.created_at as pageview_created_at,
    case when pageview_url = '/lander-1' then 1 else 0 end as lander_page,
    case when pageview_url = '/products' then 1 else 0 end as products_page,
    case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mr_fuzzy_page,
    case when pageview_url = '/cart' then 1 else 0 end as cart_page,
    case when pageview_url = '/shipping' then 1 else 0 end as shipping_page,
    case when pageview_url = '/billing' then 1 else 0 end as billing_page,
    case when pageview_url = '/thank-you-for-your-order' then 1 else 0 end as thank_you_page
from website_sessions s
	left join website_pageviews p
    on s.website_session_id = p.website_session_id
where s.created_at > '2012-08-05'
	and s.created_at < '2012-09-05' -- and '2012-09-05' -- 13841 Note: can use between with the same result
    and s.utm_campaign = 'nonbrand'
	and s.utm_source = 'gsearch'
    and p.pageview_url in ('/lander-1', '/products',  '/the-original-mr-fuzzy', '/cart', '/shipping', '/billing', '/thank-you-for-your-order')
;


-- Step2: 
-- and create temp table 

-- drop table if exists website_session_level;
-- create temporary table website_session_level
select 
	website_session_id,
    max(lander_page) as lander_page_made_it,
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
    case when pageview_url = '/lander-1' then 1 else 0 end as lander_page,
    case when pageview_url = '/products' then 1 else 0 end as products_page,
    case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mr_fuzzy_page,
    case when pageview_url = '/cart' then 1 else 0 end as cart_page,
    case when pageview_url = '/shipping' then 1 else 0 end as shipping_page,
    case when pageview_url = '/billing' then 1 else 0 end as billing_page,
    case when pageview_url = '/thank-you-for-your-order' then 1 else 0 end as thank_you_page
from website_sessions s
	left join website_pageviews p
    on s.website_session_id = p.website_session_id
where s.created_at > '2012-08-05'
	and s.created_at < '2012-09-05' -- and '2012-09-05' -- 13841 Note: can use between with the same result
    and s.utm_campaign = 'nonbrand'
	and s.utm_source = 'gsearch'
    and p.pageview_url in ('/lander-1', '/products',  '/the-original-mr-fuzzy', '/cart', '/shipping', '/billing', '/thank-you-for-your-order')
) as session_level
group by website_session_id
;


-- Check:
select * from website_session_level;


-- Step3: 

select 
	count(distinct website_session_id) as sessions,
    -- sum(lander_page_made_it),
    sum(products_made_it),
    sum(mr_fuzzy_page_made_it),
    sum(cart_page_made_it),
	sum(shipping_page_made_it),
    sum(billing_page_made_it),
    sum(thank_you_page_made_it)
from website_session_level
;


-- Step4: final step where we will calculate the clickedthrough_rate 

select 
	count(distinct website_session_id) as sessions,
    -- sum(lander_page_made_it)/count(distinct website_session_id) as to_lander_page,
    sum(products_made_it)/sum(lander_page_made_it) as to_products_page,
    sum(mr_fuzzy_page_made_it)/sum(products_made_it) as to_mr_fuzzy_page,
    sum(cart_page_made_it)/sum(mr_fuzzy_page_made_it) as to_cart_page,
	sum(shipping_page_made_it)/sum(cart_page_made_it) as to_shipping_page,
    sum(billing_page_made_it)/sum(shipping_page_made_it) as to_billing_page,
    sum(thank_you_page_made_it)/sum(billing_page_made_it) as to_thank_you_page
from website_session_level
;

-- Simulation: the result shows that the website team need to focus on lander_clicked to product_page, where it shows the low number 
			-- as well as mr_fuzzy_clicked to cart_page and shipping_page to billing_page as the low number represented
