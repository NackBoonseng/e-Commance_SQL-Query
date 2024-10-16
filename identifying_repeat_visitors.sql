-- Business Concept: Analyze Repeat Behavior

-- analyze repeat visits helps the business to understand user behavior and identify some of the most valuable customers

-- Common use case:
	-- analyzing repeat activity to see how often customer are coming back to vist the website
    -- understanding which channel they use when they come back, and whether or not the business paying for them again throughpaid channel
    -- using the repeat vist activity to build a better understadning of the value of a customer in order to better optimize marketing channels
    
-- ** Tracking Repeat Customer behavior Across multiple sessions

-- **NOTE:** The business track customer behaviors across multuple session using ** BROWSER COKKIES

	-- Furthermore, Cookies have unique ID Values associated with them, which allow the business to recognize a customer when they come back and track their nehavior over time 
    
    
    /*------------------------------------------------------------------------------------------*/
    
    -- Business Requirement: they want to know if customers have repeat sessions, they may be more valuable tha we though,
		-- So, we need to pull data on how many of our website visitors come back for another sessions, 2014 to Nov 01, 2014
        
        

Select * from website_sessions where created_at < '2014-11-01';



-- create temporary table seession_with_repeats
select
	new_sessions.user_id,
    new_sessions.website_session_id as new_session_id,
    website_sessions.website_session_id as repeat_session_id
from (
	select 
		user_id,
		website_session_id
	from website_sessions
	where created_at < '2014-11-01'
		and created_at >= '2014-01-01'
		and is_repeat_session = 0 -- this is new session only
	) as new_sessions
left join website_sessions
	on website_sessions.user_id = new_sessions.user_id
	and website_sessions.is_repeat_session = 1
    and website_sessions.website_session_id > new_sessions.website_session_id
    and created_at < '2014-11-01'
	and created_at >= '2014-01-01'
;


select
	repeat_sessions,
    count(distinct user_id) as users
from (
	select 
		user_id,
		count(distinct new_session_id) as new_sessions,
		count(distinct repeat_session_id) as repeat_sessions
	from seession_with_repeats
	group by 1
	order by 3 desc
	) as user_level
group by 1
;


-- Results: we need to learn more about the number but what we can see that customer has returned to the business 