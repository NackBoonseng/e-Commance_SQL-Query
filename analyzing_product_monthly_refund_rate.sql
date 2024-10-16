-- Business Rquirement: Suppler has some quality issue until sep 13 then they had a major issue where the bear'arm were falling off
					-- in Aud/Sep 2014, As result, the business replaced them with a new suppler on Sep 16, 2014 to Oct 15, 2014
                    -- Business require monthly product refund rate by the product, and the confirm quality isuue is now fixed
                    
                    

select * from order_item_refunds; -- order_id
select * from orders o ; -- order_id

select 
	year(i.created_at) as year,
    month(i.created_at) as month,
	count(distinct case when product_id = 1 then i.order_item_id else null end) as product1_orders,
    count(distinct case when product_id = 1 then r.order_item_refund_id else null end)
		/count(distinct case when product_id = 1 then i.order_item_id else null end) as product1_refund_rate,
	count(distinct case when product_id = 2 then i.order_item_id else null end) as product2_orders,
    count(distinct case when product_id = 2 then r.order_item_refund_id else null end)
		/count(distinct case when product_id = 2 then i.order_item_id else null end) as product2_refund_rate,
	count(distinct case when product_id = 3 then i.order_item_id else null end) as product3_orders,
    count(distinct case when product_id = 3 then r.order_item_refund_id else null end)
		/count(distinct case when product_id = 3 then i.order_item_id else null end) as product3_refund_rate,
	count(distinct case when product_id = 4 then i.order_item_id else null end) as product4_orders,
    count(distinct case when product_id = 4 then r.order_item_refund_id else null end)
		/count(distinct case when product_id = 4 then i.order_item_id else null end) as product4_refund_rate
from order_items i
	left join order_item_refunds r
    on i.order_item_id = r.order_item_id
where 
	 i.created_at < '2014-10-15'
group by 1, 2
;