-- Business Requirement: after we did analysis the number of repeated customer, 
	-- we need to know more about the minimum, the first and the second session for customer 2014 to Nov 03, 2014
    


-- Key Approaches:
	-- indentify the relevant new sessions
    -- user the user_id values from Step 1 to find any repeat sessions those users had
    -- find the created_at times fr the first and second sessions
    -- find the differenec beteen first and second sesions at a user level
    -- aggrefate he user level data o dind the average min, max


-- create temporary table sessions_with_repeat_for_time_different
select
	new_sessions.user_id,
    new_sessions.website_session_id as new_session_id,
    new_sessions.created_at as new_session_created_at,
    website_sessions.website_session_id as repeat_session_id,
    website_sessions.created_at as website_Session_created_at
from (
	select 
		user_id,
		website_session_id,
        created_at
	from website_sessions
	where created_at < '2014-11-01'
		and created_at >= '2014-01-01'
		and is_repeat_session = 0 -- this is new session only
	) as new_sessions
left join website_sessions
	on website_sessions.user_id = new_sessions.user_id
	and website_sessions.is_repeat_session = 1
    and website_sessions.website_session_id > new_sessions.website_session_id
    and website_sessions.created_at < '2014-11-01'
	and website_sessions.created_at >= '2014-01-01'
;


-- create temporary table users_first_to_second
select 
	user_id,
    datediff(second_session_created_at, new_session_created_at) as days_first_to_second_session
from (
	select 
		user_id,
		new_session_id,
		new_session_created_at,
		min(repeat_session_id) as second_session_id,
		min(website_Session_created_at) as second_session_created_at
	from sessions_with_repeat_for_time_different
	where repeat_session_id is not null 
	group by 1, 2, 3
	) as first_second
;



select 
	avg(days_first_to_second_session) as avg_days_to_second,
    min(days_first_to_second_session) as min_days_first_to_second,
    max(days_first_to_second_session) as max_days_to_second
from users_first_to_second;

-- Result: as the number shows that, the busiess has recieved the number of customer returns but we need to delve into which
	-- channels the cutomers has returns whether it paid traffic, organic traffic or direct type-in
	-- so that we might be able to minimise the cost for our marketing 
    
    

