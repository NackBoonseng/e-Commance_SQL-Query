-- Business requirement: the business want to improve the business customer esperience by adding live chat support to the website
		-- the business wnat to know the avaerage website session volumn, by hour of day and by day week
        -- avoid the holidays time period and the date range of sep 13 - nov 15, 2012
        
        
select 
	hour(s.created_at) as hour,
    -- s.created_at,
    -- count(distinct s.website_session_id) as session,
    -- s.website_session_id,
    -- weekday(s.created_at) as week_day,
    count( distinct case when weekday(s.created_at) = 0 then s.website_session_id else null end) as Mon,
    count( distinct case when weekday(s.created_at) = 1 then s.website_session_id else null end) as Tue,
    count( distinct case when weekday(s.created_at) = 2 then s.website_session_id else null end) as Wed,
    count( distinct case when weekday(s.created_at) = 3 then s.website_session_id else null end) as Thr,
    count( distinct case when weekday(s.created_at) = 4 then s.website_session_id else null end) as Fri,
    count( distinct case when weekday(s.created_at) = 5 then s.website_session_id else null end) as Sat,
    count( distinct case when weekday(s.created_at) = 6 then s.website_session_id else null end) as Sun
from website_sessions s 
where s.created_at between '2012-09-13' and '2012-11-15'
group by hour(s.created_at)
;

-- The result shows the volumn but not overall


-- Then, the next systax will show the average 

select 
	date(s.created_at) as created_date,
    weekday(s.created_at) as week_day,
    hour(s.created_at) as hour,
    count(distinct s.website_session_id) as website_sessions
from website_sessions s
where s.created_at between '2012-09-13' and '2012-11-15'
group by 1,2,3
;

-- Then, we will use subquery to find the average

select 
	hour,
    -- round(avg(website_sessions), 1) as avg_session,
    round(avg(case when week_day = 0 then website_sessions else null end), 1) as Mon,
    round(avg(case when week_day = 1 then website_sessions else null end), 1) as Tue,
    round(avg(case when week_day = 2 then website_sessions else null end), 1) as Wed,
    round(avg(case when week_day = 3 then website_sessions else null end), 1) as Thr,
    round(avg(case when week_day = 4 then website_sessions else null end), 1) as Fri,
    round(avg(case when week_day = 5 then website_sessions else null end), 1) as Sat,
    round(avg(case when week_day = 6 then website_sessions else null end), 1) as Sun
from (
	select 
	date(s.created_at) as created_date,
    weekday(s.created_at) as week_day,
    hour(s.created_at) as hour,
    count(distinct s.website_session_id) as website_sessions
from website_sessions s
where s.created_at between '2012-09-15' and '2012-11-15'
group by 1,2,3
) as daily_hourly_session
group by hour
order by hour
;