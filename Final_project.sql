


-- Final Business Reqirement for mzfuzzy:

-- Based on the requirements:
	
    -- 1. 
    /*the volumn growth by pulling overall session and order volumn, trended by quater 
		-- for the first life of business */
        
use mavenfuzzyfactor;


select 
	year(s.created_at) as year,
    quarter(s.created_at) as quar,
    count(distinct s.website_session_id) as sessions,
    count(distinct o.order_id) as orders
from website_sessions s
	left join orders o
    on s.website_session_id = o.website_session_id
group by 1, 2
order by 1, 2
;


-- 2
 /* efficiency improvement, show quarterly figures since the business launcehed, for session to orders conversion rate, revenue per order and
	-- revenue per sessions*/
    
    
select 
	year(s.created_at) as year,
    quarter(s.created_at) as quar,
    count(distinct o.order_id) 
		/count(distinct s.website_session_id) as session_to_order_conv_rate,
	sum(price_usd)
		/count(distinct o.order_id) as revenue_per_orders,
	sum(price_usd)
		/count(distinct s.website_session_id) as revenue_per_session
from website_sessions s
	left join orders o
    on s.website_session_id = o.website_session_id
group by 1, 2
order by 1, 2
;


-- 3.
	/* show spesific channels, pull a quarterly view of orders from gsearch nonbrand, bsearch nonbrand, brand search overall, organic search
		--and direct-type-in*/
        
        
	select 
	year(s.created_at) as year,
    quarter(s.created_at) as quar,
    count(distinct case when utm_source = 'gsearch' and utm_campaign = 'nonbrand' then o.order_id else null end) as gsearch_nonbrand_orders,
	count(distinct case when utm_source = 'bsearch' and utm_campaign = 'nonbrand' then o.order_id else null end) as bsearch_nonbrand_orders,
	count(distinct case when utm_campaign = 'brand' then o.order_id else null end) as brand_search_orders,
	count(distinct case when utm_source is null and http_referer is not null then o.order_id else null end) as organic_search_orders,
    count(distinct case when utm_source is null and http_referer is null then o.order_id else null end) as direct_type_in_orders
from website_sessions s
	left join orders o
    on s.website_session_id = o.website_session_id
group by 1, 2
order by 1, 2
;


-- 4.
	/* show the overall session to orders conversion rate trends for those same channels, 
	by quater, including a note of any period where the business made a major improvement or optimization*/
    
    
select 
	year(s.created_at) as year,
    quarter(s.created_at) as quar,
    count(distinct case when utm_source = 'gsearch' and utm_campaign = 'nonbrand' then o.order_id else null end)
		/count(distinct case when utm_source = 'gsearch' and utm_campaign = 'nonbrand' then s.website_session_id else null end) as gsearch_nonbrand_conv_rate,
	count(distinct case when utm_source = 'bsearch' and utm_campaign = 'nonbrand' then o.order_id else null end)
		/count(distinct case when utm_source = 'bsearch' and utm_campaign = 'nonbrand' then s.website_session_id else null end) as bsearch_nonbrand_conv_rate,
	count(distinct case when utm_campaign = 'brand' then o.order_id else null end)
		/count(distinct case when utm_campaign = 'brand' then s.website_session_id else null end) as brand_search_conv_rate,
	count(distinct case when utm_source is null and http_referer is not null then o.order_id else null end)
		/count(distinct case when utm_source is null and http_referer is not null then s.website_Session_id else null end) as organic_search_conv_rate,
    count(distinct case when utm_source is null and http_referer is null then o.order_id else null end)
		/count(distinct case when utm_source is null and http_referer is null then s.website_Session_id else null end) as direct_type_in_conv_rate
from website_sessions s
	left join orders o
    on s.website_session_id = o.website_session_id
group by 1, 2
order by 1, 2
;


-- 5.
	/* the business has been opening up for quite q long tiem for selling single product
    so, pull monthly trending for revenue and margin by products, along with total sales and revenue 
    if there is anything notice about seasonality*/
  
  
  select * from products;
  select * from order_items;
  
  	select 
	year(created_at) as year,
    month(created_at) as month,
    sum(case when product_id = 1 then price_usd else null end) as mr_fuzzy_revenue,
    sum(case when product_id = 1 then price_usd - cogs_usd else null end) as mr_fuzzy_margin, -- cog = cost of goods
     sum(case when product_id = 2 then price_usd else null end) as lovebear_revenue,
    sum(case when product_id = 2 then price_usd - cogs_usd else null end) as loverbear_margin,
     sum(case when product_id = 3 then price_usd else null end) as birthdaybear_revenue,
    sum(case when product_id = 3 then price_usd - cogs_usd else null end) as birthdaybear_margin,
     sum(case when product_id = 4 then price_usd else null end) as minibear_revenue,
    sum(case when product_id = 4 then price_usd - cogs_usd else null end) as minibear_margin,
    sum(price_usd) as total_revenue,
    sum(price_usd - cogs_usd) as total_margin
from order_items
group by 1, 2
order by 1, 2
;


-- 6.
	/* let's drive deeper into the impact of introducting new product, 
    pull monthly session to the /product page and show the % of those session clicking through another page has change
    over time, along with a vuew of how conversion from / product to placing an order has inproved*/
    
    
-- First, identify all the views f the product page

-- create temporary table product_pageviews
select 
	website_session_id,
    website_pageview_id,
    created_at as saw_product_page_at
from website_pageviews
where pageview_url = '/products'
;

-- then,

select 
	year(saw_product_page_at) as year,
    month(saw_product_page_at) as month,
    count(distinct p.website_session_id) as session_to_product_page,
    count(distinct w.website_session_id) as clicked_to_next_page,
    count(distinct w.website_session_id)
		/count(distinct p.website_session_id) as clicked_through_rate,
	count(distinct o.order_id) as orders,
    count(distinct o.order_id)
		/count(distinct p.website_session_id) as product_to_order_rate
from product_pageviews p
	left join website_pageviews w
		on p.website_session_id = w.website_session_id -- same session
	and w.website_pageview_id > p.website_pageview_id -- they had another page after: identify for user to see another pages after see the product page
	left join orders o
		on o.website_session_id = p.website_session_id
group by 1, 2
;
		

-- 7. 
	/*the business has mand 4th product available as a primary product on Dec 05, 2014 (it was previously only a cross-sell item)
    , we need to pull sales data since then, and show how well each product cross-sells from one another */
    
-- create temporary table primary_product
select 
	order_id,
    primary_product_id,
    created_at as ordered_at
from orders
where created_at > '2014-12-05'
;

-- Being in sub query to see which product is cross-sell to which product
select 
	p.*,
    o.product_id as cross_sell_product_id
from primary_product p
	left join order_items o
    on p.order_id = o.order_id
    and o.is_primary_item = 0 -- only bringing only cross-sell
;
	
select 
	primary_product_id,
    count(distinct order_id) as orders,
    count(distinct case when cross_sell_product_id = 1 then order_id else null end) as sold_product_1,
    count(distinct case when cross_sell_product_id = 2 then order_id else null end) as sold_product_2,
    count(distinct case when cross_sell_product_id = 3 then order_id else null end) as sold_product_3,
    count(distinct case when cross_sell_product_id = 4 then order_id else null end) as sold_product_4,
    count(distinct case when cross_sell_product_id = 1 then order_id else null end)/count(distinct order_id) as product_1_sell_rate,
    count(distinct case when cross_sell_product_id = 2 then order_id else null end)/count(distinct order_id) as product_2_sell_rate,
    count(distinct case when cross_sell_product_id = 3 then order_id else null end)/count(distinct order_id) as product_3_sell_rate,
    count(distinct case when cross_sell_product_id = 4 then order_id else null end)/count(distinct order_id) as product_4_sell_rate
from (
	select 
		p.*,
		o.product_id as cross_sell_product_id
	from primary_product p
		left join order_items o
		on p.order_id = o.order_id
		and o.is_primary_item = 0
	 ) as primary_product_with_cross_sell
group by 1
;


	
    

    
    

