SELECT 
    primary_product_id,
    -- order_id,
    -- items_purchased,
    count(distinct case when items_purchased = 1 then order_id else null end) as Count_single_item_orders,
    count(distinct case when items_purchased = 2 then order_id else null end) as Count_two_item_orders
FROM
    orders
WHERE
    order_id BETWEEN 31000 AND 32000
group by 1
;