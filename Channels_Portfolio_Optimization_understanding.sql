-- Business Concept: Channel Portfolio optimization
-- A portfolio of marketing channel is about bidding efficiently and using data to maximise the effectiveness of the marketin gbudget 

-- Common Use Cases:
	-- Understanding which marketing channels are driving the most session and orders through the website
    -- Understanding differnecs in user charesteritics and conversion perfornace across marketing channels
    -- Optimizing bids and allocating marketing spend across a multi-channel portfolion to achieve maximun perfomance 
    

-- Paid Marketing Review Campaigns: Tracking Parameters (Review)
-- Info: when bisuness run paid marketing campaigns, they often obsess over performance and measure everythings
		-- how much they spend, how well traffic converts to sales etc
        
-- Paid traffic is commonly tagged with tracking (UTM) parameters, which are appended to URLs and allow us to tie website activity back
-- to specify traffic sources and campaigns


select 
	utm_content,
    count( distinct s.website_session_id) as session,
    count( distinct o.order_id) as orders,
    count( distinct o.order_id)/count( distinct s.website_session_id) as conversion_rate
from website_sessions s
	left join orders o
    on s.website_session_id = o.website_session_id
where s.created_at between '2014-01-01' and '2014-02-01'
group by 1
order by session desc
;

-- Note: Null might a direct traffic 
-- Conversion rate refer to portfolio channels(utm_content) per count of session(session) and how many session that converts to order(orders)
	-- see that g_ad_1 is lower than g_ad_2, which means the change of g_ad_2 is successfull in terms of improvement 