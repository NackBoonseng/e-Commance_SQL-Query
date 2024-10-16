-- Buinsess Concept: Analyzing direct traffic
 -- Analyzing the company branded or direct traffic is about keeping a pulse on how well
 -- the brand is doing with consumers, and how well the brand drives business
 
-- Simplify: If customer directly types in the brand in search box, that turns out very good bc the compay dont need to pay
	-- for the domain and that shows the brand is out in the market 
    
-- Common Use Cases: 1. identify how muc revenue the company generating from direct traffic- this is high margin revenue without a direcr cost of
					-- customer asquisition
				  -- 2. understading wether or not a paid traffic is generating a "halo" effect and promoting additional direct traffic
                  -- 3. assessing the impact of various initiative on how many customer seek out the business
                  
select 
	*
from website_sessions s
where s.website_session_id between 100000 and 115000 -- arbitrary range
;
        
-- some nulls in utm_source and utm_campaign 
-- we need to have a look on direct type in 
        
select 
		*
from website_sessions s
where s.website_session_id between 100000 and 115000 -- arbitrary range
; -- http_referer represent if the value is null, means the customer direct types in 
						-- otherwise, if there is a value, means it is organic search
                        
-- Next:

select 
        case
			when s.http_referer is null then 'direct_type_in'
            when s.http_referer = 'https://www.gsearch.com' and s.utm_source is null then 'gsearch_organic'
            when s.http_referer = 'https://www.bsearch.com' and s.utm_source is null then 'bsearch_organic'
            else 'other'
		end,
        count(distinct s.website_session_id) as session
from website_sessions s
where s.website_session_id between 100000 and 115000 -- arbitrary range
	-- and s.utm_source is null
group by 1
order by 2 desc
; 

-- The result: that show the volumn of all traffic in the company (other = direct" 
