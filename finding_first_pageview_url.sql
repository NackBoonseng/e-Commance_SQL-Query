
-- Step 1: find the first pageview for each session ( the first website_pageview_id that the user(website_session_id look at the website)
/* Clarification on the database: 
Website_session_id = the first time user log in to the website and then continue their browsing, which can lead to other action.
Ex. website_Session_id = 6, start in pageview_url = /home and then continue to pageview_product = /product and so on
*/ 

-- Step 2: find the url that customer saw on that first pageview

create temporary table first_pageview_per_session
SELECT 
    website_session_id,
    min(website_pageview_id) as min_pageview
FROM
    website_pageviews
WHERE
    created_at < '2012-06-12'
group by 1
;

-- Additional step: to see the JOIN fuction where left join will only retrive the columns from website_pageview that match to temp table 
-- Instance: the first user log in (website_session_id) return to the first website_pageview_id (the first website_pageview) that users see
SELECT 
    *
FROM
    first_pageview_per_session f
        LEFT JOIN website_pageviews w 
        ON f.min_pageview = w.website_pageview_id
;
-- Next step: get the business requirement = website_pageview_url, group by the session 

SELECT 
    w.pageview_url as first_entry_pageview_url,
    count(distinct f.website_session_id) as session_hitting_page
FROM
    first_pageview_per_session f
        LEFT JOIN website_pageviews w 
        ON f.min_pageview = w.website_pageview_id
group by 1
;


/* Result: Still obvious that home page is still top priority( think about what matrix that homepage is the best initial expeience)