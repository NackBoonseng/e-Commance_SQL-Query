-- Business Concept: Cross-selling Product
	
    -- Cross-sell analysis is about understanding which products users are most likely tp purchase together, and offering smart product reccomendation
    -- ex. if the business has product a, b, c, d and e = the customer might want to buy product a and c together but not a and e
    

-- Commom use case:
	-- understanding which products are often purchased together
    -- testing and optimizing the eay you cross-sell products on the website
    -- understanding the conversion rate impact of trying to cross sell additional product
    


select 
	*
from orders
where order_id between 10000 and 11000
; -- item_puchased > 1 that means there is cross-selling product


select 
	*
from order_items
where order_id between 10000 and 11000
; -- order_id = 10012/product_id = 1 & another order_id = 10012/product_id = 3 ** is_promary_item**



select 
    o.primary_product_id,
    count(distinct o.order_id) as orders,
    count(distinct case when i.product_id = 1 then o.order_id else null end) as cross_sell_product1,
	count(distinct case when i.product_id = 2 then o.order_id else null end) as cross_sell_product2,
    count(distinct case when i.product_id = 3 then o.order_id else null end) as cross_sell_product3,
    
	count(distinct case when i.product_id = 1 then o.order_id else null end)/count(distinct o.order_id) as cross_sell_product1_rt,
	count(distinct case when i.product_id = 2 then o.order_id else null end)/count(distinct o.order_id) as cross_sell_product2_rt,
    count(distinct case when i.product_id = 3 then o.order_id else null end)/count(distinct o.order_id) as cross_sell_product3_rt
from orders o
	left join order_items i
    on o.order_id = i.order_id
    and i.is_primary_item = 0 -- cross sell only
where o.order_id between 10000 and 11000
group by 1
; 