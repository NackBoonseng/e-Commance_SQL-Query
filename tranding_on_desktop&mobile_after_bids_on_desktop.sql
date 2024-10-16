SELECT 
    -- year(w.created_at) as yr,
    -- week(w.created_at) as wk,
    min(date(w.created_at)) as Week_start_at,
    count(distinct case when device_type = 'mobile' then w.website_session_id else null end) as mobile_session,
    count(distinct case when device_type = 'desktop' then w.website_session_id else null end) as desktop_session
    -- count(distinct w.website_session_id) as Total_Session
FROM
    website_sessions w
WHERE
    w.created_at < '2012-06-09'
		and w.created_at > '2012-04-15'
        AND w.utm_source = 'gsearch'
        AND w.utm_campaign = 'nonbrand'
group by 
	year(w.created_at),
    week(w.created_at)
;

/* Analysis shows that mobile is slightly dropping down but because previous analysis helped the marketing team to bid more on 
desktop so that the volumn of desktop is strong Congrat it's worth to invest on desktop*/