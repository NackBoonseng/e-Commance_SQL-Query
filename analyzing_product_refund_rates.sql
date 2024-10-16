-- Business Concept: Product Refund analysis


-- Analyzing prodyct refund rate is about controlling for quality and understanding where you mihgt have problems to address

-- Common Use Case:
	-- Monotoring product from different supplier
    -- Understainf refund rates for product at different price points
    -- Takling product refund rates and the associated costs into account when asessing the overall performance of business
    
    
    
    select 
		i.order_id,
        i.order_item_id,
        i.price_usd as price_paid_usd,
        i.created_at,
        r.order_item_refund_id,
        r.refund_amount_usd,
        r.created_at
	from order_items i
		left join order_item_refunds r
        on i.order_item_id = r.order_item_id
	where i.order_id in (3489, 32049, 27061)
    ; 