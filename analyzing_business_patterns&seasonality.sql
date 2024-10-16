-- Business Concepts: Analyzing seasonality & business petterns
-- analyzing business petterns is about generating insights to help the business maximise effiency and anticipate future trends

-- Common Use Cases:
	-- 1. Day-parting analysis to understand hoe much support staff the business should have at different of days or days of the week
    -- 2. analysing seasonality to better prepare for upcoming spikes or slowdowns in demand 
    
    
use mavenfuzzyfactory;
select 
		s.website_session_id,
        s.created_at,
        hour(s.created_at) as hours,
        weekday(s.created_at) as week_day, -- 0 = Monday, 1= Tue etc
			case
				when weekday(s.created_at) = 0 then 'Monday' 
                when weekday(s.created_at) = 1 then 'Tuesday'
                when weekday(s.created_at) = 2 then 'Wednesday'
                when weekday(s.created_at) = 3 then 'Thuesday'
                when weekday(s.created_at) = 4 then 'Friday'
                when weekday(s.created_at) = 5 then 'Saturday'
                when weekday(s.created_at) = 6 then 'Sunday'
                else 'other_day'
                end as day_name,
        quarter(s.created_at) as quarter,
        month(s.created_at) as month,
        date(s.created_at) as date,
        week(s.created_at) as week
from website_sessions s
where s.website_session_id between 150000 and 155000
;