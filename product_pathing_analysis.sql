-- Business Requirement: lanuch a new product, they want to know user path & conversion since Jan 6 and compare to the 3 months leading up to the launch



-- the business requirement: product pathing analysis

-- Key approaches:
	-- 1. find the relevant product pageview with website_session_id
    -- 2. find the next pageview id that occurs AFTER** theproduct pageview
    -- 3. find the pageview_url associated with any applicablenet pageview_id
    -- 4. summerise the data and analyze the pre vs post period 
    
    
    
-- Step1: finding the product pageview that we need to dig in more detail

-- create temporary table product_pageviews
select 
	website_session_id,
    website_pageview_id,
    created_at,
    case
		when created_at < '2013-01-06' then 'A.Pre_product_2'
        when created_at >= '2013-01-06' then 'B.Post_product_2' -- the product has launched 
        else 'Check_the_logic'
        end as time_period
from website_pageviews
where created_at < '2013-04-06' -- date of business requires
	and created_at > '2012-10-06' -- start of 3 months before product 2 launch 
	and pageview_url = '/products'
;


-- step 2: find the next pageview id that occurs AFTER** the product pageview

-- create temporary table session_with_next_pageview_id
select 
	p.time_period,
    p.website_session_id,
    min(w.website_pageview_id) as min_next_pageview_id
from product_pageviews p
	left join website_pageviews w
    on p.website_session_id = w.website_session_id
	and w.website_pageview_id > p.website_pageview_id -- we will focus on pageview_id AFTER** the product has launched
group by
	1, 2
;

-- step3: find the pageview_url associated with any applicable next pageview_id

-- create temporary table session_with_next_pageview_url
select
	s.time_period,
    s.website_session_id,
    p.pageview_url as next_pageview_url
from session_with_next_pageview_id s
	left join website_pageviews p
    on p.website_pageview_id = s.min_next_pageview_id
-- where not p.pageview_url = '/the-original-mr-fuzzy' = check the logic if there is another pageview_url
;


-- step4: summerise the data and analyze the pre vs post periods 

select 
	time_period,
    count(distinct website_session_id) as sessions,
    count(distinct case when next_pageview_url is not null then website_session_id else null end) as with_next_pageview,
    count(distinct case when next_pageview_url is not null then website_session_id else null end)/
		count(distinct website_session_id) as percentage_with_next_pageview,
    count(distinct case when next_pageview_url = '/the-original-mr-fuzzy' then website_session_id else null end) as to_mrfuzzy,
    count(distinct case when next_pageview_url = '/the-original-mr-fuzzy' then website_session_id else null end)/
		count(distinct website_session_id) as percentage_to_mrfuzzy,
	count(distinct case when next_pageview_url = '/the-forever-love-bear' then website_session_id else null end) as to_lovebear,
    count(distinct case when next_pageview_url = '/the-forever-love-bear' then website_session_id else null end)/
		count(distinct website_session_id) as percentage_to_loverbear
from session_with_next_pageview_url
group by 1
;


-- Result: tje percen of myfuzzy has gone down so adding additional new product is positive as we can sess on percentage_with_next_pageview has alightly gone up 



    

