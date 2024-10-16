-- Business requirement since 6 Jan, they need to know the conversion funnels from each product page to conversion
	-- and a comparison between the two conversion funnels for all website traffic
    


-- Key approaches: 
	-- step 1: select all pageviews for relevant session
    -- step2: figure out with pageview_urls to look for
    -- step3: pull all pageview and indentify the funnels steps
    -- step4: create the sesion -level conversion funnel view
    -- step5: aggregate the data to assess funnel performance
    
    
-- step1:

--  temporary table session_seeing_product_page
select
	website_session_id,
    website_pageview_id,
    pageview_url as product_page_seen
from website_pageviews
where created_at < '2013-04-10'
	and created_at > '2013-01-06'
    and pageview_url in ('/the-original-mr-fuzzy', '/the-forever-love-bear')
;


-- finding the right pageview_urls to build the funnels

select 
	w.pageview_url
from session_seeing_product_page s
	left join website_pageviews w
    on w.website_session_id = s.website_session_id
    and w.website_pageview_id > s.website_pageview_id
group by 1
;


-- then we will look at the inner query first ti look over the pageview_level results
-- then, turn it into a sub and make it the summary with flags

select 
	s.website_session_id,
    s.product_page_seen,
	case when pageview_url = '/cart' then 1 else 0 end as cart_page,
    case when pageview_url = '/shipping' then 1 else 0 end as shipping_page,
    case when pageview_url = '/billing-2' then 1 else 0 end as billing_page,
    case when pageview_url = '/thank-you-for-your-order' then 1 else 0 end as thank_you_page
from session_seeing_product_page s
	left join website_pageviews w
    on w.website_session_id = s.website_session_id
    and w.website_pageview_id > s.website_pageview_id
order by 1, 2
;


-- Next:

-- create temporary table session_product_level_made_it_flags
select 
	website_session_id,
    case
		when product_page_seen = '/the-original-mr-fuzzy' then 'mrfuzzy'
        when product_page_seen = '/the-forever-love-bear' then 'lovebear'
        else 'check_the_logic'
	end as product_seen,
    max(cart_page) as cart_made_it,
    max(shipping_page) as shipping_made_it,
    max(billing_page) as billing_made_it,
    max(thank_you_page) as thankyou_made_it
from (
select 
	s.website_session_id,
    s.product_page_seen,
	case when pageview_url = '/cart' then 1 else 0 end as cart_page,
    case when pageview_url = '/shipping' then 1 else 0 end as shipping_page,
    case when pageview_url = '/billing-2' then 1 else 0 end as billing_page,
    case when pageview_url = '/thank-you-for-your-order' then 1 else 0 end as thank_you_page
from session_seeing_product_page s
	left join website_pageviews w
    on w.website_session_id = s.website_session_id
    and w.website_pageview_id > s.website_pageview_id
order by 1, 2) as pageview_level
group by 
	website_session_id,
	case
		when product_page_seen = '/the-original-mr-fuzzy' then 'mrfuzzy'
        when product_page_seen = '/the-forever-love-bear' then 'lovebear'
        else 'check_the_logic'
	end 
;

-- Final step:


select 
	product_seen,
    count(distinct website_session_id) as sessions,
    count(distinct case when cart_made_it = 1 then website_session_id else null end) as to_cart,
    count(distinct case when shipping_made_it = 1 then website_session_id else null end) as to_cart,
    count(distinct case when billing_made_it = 1 then website_session_id else null end) as to_cart,
    count(distinct case when thankyou_made_it = 1 then website_session_id else null end) as to_cart
from session_product_level_made_it_flags
group by
	1
;


-- then, final output for click_rates
select 
	product_seen,
    -- count(distinct website_session_id) as sessions,
    count(distinct case when cart_made_it = 1 then website_session_id else null end)/
		count(distinct website_session_id)  as product_click_rate,
    count(distinct case when shipping_made_it = 1 then website_session_id else null end)/
		count(distinct case when cart_made_it = 1 then website_session_id else null end)  as cart_click_rate,
    count(distinct case when billing_made_it = 1 then website_session_id else null end)/
		count(distinct case when shipping_made_it = 1 then website_session_id else null end)  as shipping_click_rate, 
    count(distinct case when thankyou_made_it = 1 then website_session_id else null end)/
		count(distinct case when billing_made_it = 1 then website_session_id else null end)  as billing_click_rate
from session_product_level_made_it_flags
group by 1
;


-- Result: product_page_click_rate has slightly more click rate to mrfuzzy




    
