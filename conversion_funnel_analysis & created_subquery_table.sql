-- Business Concept: Analyzing & testing coversional funnel(Business marketing representing a potential customer's journey from first aware of products to becoming a paying customer
					-- In this case, is about understanding and optimizing each step of uses's experience toward purchasing products
                    
-- Common Use Case: 
		-- identifying the most common paths customers take before purchasing the products 
		-- identifying how many of customer continue on to each next step in the conversion flow, and how many user abandon at each step
        -- optimizing critical paon point where users are abandoning, so that we can convert more users and sell more products


-- Key takeaway: from data(website_pageviews)

select * from website_pageviews where website_session_id = 1059;

-- Using: SUBQUERIES
-- Systax: select columnname from (SUBQUERIES) NOTE: completed query on its own & has Alias 
-- Comparision: Temp table is similar to SUBQUERIES 

--------------------------------------------------------------------------------------------------

-- Business Context:
	-- we want to build a mini conversona funnel, from /lander_2 to/Cart
    -- we want tp know how many people reach steao and also afopoff rates
    -- for simplicity of the testing, we are looking ar /lander_2 traffic only
    -- for simplicity of the testing, we are looking at customers who like Mr Fuzzy only
    
-- Step1: select all pageviews for releant session
-- Step2: identify eacg relevent pageview as the spesific funnerl steo
-- Step3: create the session_level conversion funnerl view
-- Step4: aggerate the dat to asess funnel performance 

-- Step1:

Select 
	s.website_session_id,
    p.pageview_url,
    p.created_at as pageview_created_at,
    case when p.pageview_url = '/products' then 1 else 0 end as product_page, -- we flags the product page as 1
    case when p.pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mr_fuzzy_page,
    case when p.pageview_url = '/cart' then 1 else 0 end as cart_page
from website_sessions s
	left join website_pageviews p
    on s.website_session_id = p.website_session_id
where s.created_at between '2014-01-01' and '2014-02-01' -- random tiamframe
	and p.pageview_url in('/lander-2', '/products','/the-original-mr-fuzzy', '/cart')
order by s.website_session_id
;


-- next we, well put the previous query inside a sub query (like "Temp table"
-- then, we will group by website_session_id and thale the Max() of each of the flags
-- this Max() become a made_it flag for that session, to show the sesiion made it there

-- create temporary table session_made_it_level
select 
	website_session_id,
    max(product_page) as product_made_it,
    max(mr_fuzzy_page) as mr_fuzzy_page_made_it,
    max(cart_page) as cart_page_made_it
from (
Select 
	s.website_session_id,
    p.pageview_url,
    p.created_at as pageview_created_at,
		case when p.pageview_url = '/products' then 1 else 0 end as product_page, -- we flags the product page as 1
		case when p.pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mr_fuzzy_page,
		case when p.pageview_url = '/cart' then 1 else 0 end as cart_page
from website_sessions s
	left join website_pageviews p
    on s.website_session_id = p.website_session_id
where s.created_at between '2014-01-01' and '2014-02-01' -- random tiamframe
	and p.pageview_url in('/lander-2', '/products','/the-original-mr-fuzzy', '/cart')
order by s.website_session_id
) as pageview_level

group by website_session_id -- the result show the length of pageview_session_id, where the customer has entered the website and made the progress in the specific session
;


-- Check:
select * from  session_made_it_level;

-- then, we will produce final output (part 1) - the count of session_id on product_page, mr_fuzzy_page and cart_page

select 
	count(distinct website_session_id) as sessions,
    count(distinct case when product_made_it = 1 then website_session_id else null end) as to_products,
    count(distinct case when mr_fuzzy_page_made_it = 1 then website_session_id else null end) as to_mr_fuzzy_page,
    count(distinct case when cart_page_made_it = 1 then website_session_id else null end) as to_cart_page
from session_made_it_level
;

-- then, we will translate those counts to clieck rate for final output part 2(click rate)

select 
	count(distinct website_session_id) as sessions,
    count(distinct case when product_made_it = 1 then website_session_id else null end) 
    /count(distinct website_session_id) as lander_clickedthrough_rate, -- simplify this as the session_id, started from lander-2_page then the user clickedthrough product_page
    count(distinct case when mr_fuzzy_page_made_it = 1 then website_session_id else null end) 
    /count(distinct case when product_made_it = 1 then website_session_id else null end) as products_clickedthrough_rate, -- as product_page, the cuser clickedthorugh mr_fuzzy_page
    count(distinct case when cart_page_made_it = 1 then website_session_id else null end) 
    /count(distinct case when mr_fuzzy_page_made_it = 1 then website_session_id else null end) as mr_fuzzy_page_clickedthough_rate 
from session_made_it_level
;



