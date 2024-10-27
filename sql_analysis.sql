-- How many orders are there in the dataset?
select 
	count(*)
from magist.orders
;
-- Are orders actually delivered?
select 
	order_status,
    count(*) as qty,
	count(*)/(select count(*) from magist.orders) as share_of_orders
from magist.orders
group by 1
order by 2 desc
;
-- Is Magist having user growth?
select 
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m-01') AS truncated_date,
    count(*) as qty
from magist.orders
group by 1
order by 1
;
-- How many products are there on the products table?
select 
	count(*) as products,
    count(distinct product_id) as unique_products
from magist.products
;
-- Which are the categories with the most products?
select 
	product_category_name,
    count(*) as products
from magist.products
group by 1
order by 2 desc
limit 10
;
-- How many of those products were present in actual transactions?
select 
	count(*) as order_items,
    count(distinct product_id) as actual_products,
    (select count(*) as products from magist.products) as available_products
from magist.order_items
;
-- What’s the price for the most expensive and cheapest products?
select 
	min(price) as min_price,
    max(price) as max_price
from magist.order_items
;
-- What are the highest and lowest payment values? 
select
	min(payment_value) as min_payment_value,
    max(payment_value) as max_payment_value
from magist.order_payments
;
select
	order_id,
    sum(payment_value) as payment,
	count(*) as items
from magist.order_payments
group by 1
order by 2
limit 7
;
select
	order_id,
    sum(payment_value) as payment,
	count(*) as items
from magist.order_payments
group by 1
order by 2 desc
limit 7
;
-- products
select *
from magist.product_category_name_translation
;
select sum(price)
from magist.order_items
;
select *
from magist.order_payments
;
select 
	-- c.product_category_name_english,
    case 
		when c.product_category_name_english in ('computers_accessories',
			'telephony',
			'computers',
			'electronics',
			'audio') then 'Tech'
		else 'Non-tech' 
        end 
        as new_category_name,
    count(distinct a.product_id) as unique_products,
    count(*) as sold_order_items,
    sum(a.price) as total_order_value,
    avg(a.price) as avg_item_price
from magist.order_items a
left join magist.products b
	on a.product_id = b.product_id
left join magist.product_category_name_translation c
	on b.product_category_name = c.product_category_name
group by 1
order by 3 desc
;
select 
	-- c.product_category_name_english,
    case 
		when c.product_category_name_english in ('computers_accessories',
			'telephony',
			'computers',
			'electronics',
			'audio') then 'Tech'
		else 'Non-tech' 
        end 
        as new_category_name,
        -- ceil(a.price/500)*500 as price_bucket,
        case when a.price <=540 then 'cheaper'
			else 'expensive'
            end
		as price_bucket,
    count(distinct a.product_id) as unique_products,
    sum(a.price) as total_order_value,
    avg(a.price) as avg_item_price
from magist.order_items a
left join magist.products b
	on a.product_id = b.product_id
left join magist.product_category_name_translation c
	on b.product_category_name = c.product_category_name
group by 1,2
order by 1,2
;
-- sellers
select 
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m-01') AS truncated_date,
    count(*) as qty
from magist.orders
group by 1
order by 1
;
select 
	-- c.product_category_name_english,
    case 
		when c.product_category_name_english in ('computers_accessories',
			'telephony',
			'computers',
			'electronics',
			'audio') then 'Tech'
		else 'Non-tech' 
        end 
        as new_category_name,
    count(distinct a.seller_id) as unique_sellers,
    count(*) as sold_order_items,
    sum(a.price) as total_order_value
from magist.order_items a
left join magist.products b
	on a.product_id = b.product_id
left join magist.product_category_name_translation c
	on b.product_category_name = c.product_category_name
group by 1
order by 1
;
select 
    DATE_FORMAT(shipping_limit_date, '%Y-%m-01') AS truncated_date,
    count(distinct a.seller_id) as unique_sellers,
    count(*) as sold_order_items,
    sum(a.price) as total_order_value,
    sum(a.price)/count(distinct a.seller_id) as avg_seller_income
from magist.order_items a
left join magist.products b
	on a.product_id = b.product_id
left join magist.product_category_name_translation c
	on b.product_category_name = c.product_category_name
group by 1
order by 1
;

select 
    case 
		when c.product_category_name_english in ('computers_accessories',
			'telephony',
			'computers',
			'electronics',
			'audio') then 'Tech'
		else 'Non-tech' 
        end 
        as new_category_name,
	DATE_FORMAT(shipping_limit_date, '%Y-%m-01') AS truncated_date,
    count(a.seller_id) as unique_sellers,
    count(*) as sold_order_items,
    sum(a.price) as total_order_value,
    sum(a.price)/count(distinct a.seller_id) as avg_seller_income
from magist.order_items a
left join magist.products b
	on a.product_id = b.product_id
left join magist.product_category_name_translation c
	on b.product_category_name = c.product_category_name
group by 1,2
order by 1,2
;
-- delivery_time
select 
	order_id,
    DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) AS delivery_days,
    DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) AS delay_days
from magist.orders
;
select 
    avg(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS delivery_days
from magist.orders
;
select 
	case 
		when DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) > 0 then 1
        else 0
	end
    as delay_flg,
	count(order_id) as order_cnt
from magist.orders
group by 1
order by 1
;
select *
from magist.orders
;
select *
from magist.products
;
select 
	order_id,
    sum(product_weight_g) as product_weight_g
from magist.order_items a
left join magist.products b
	on a.product_id = b.product_id
group by 1
;
-- 3.3.3
select 
	case 
		when DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) > 0 then 1
        else 0
	end
    as delay_flg,
	count(*) as order_cnt,
    avg(product_weight_g) as avg_weight
from magist.orders a
left join (
	select 
		order_id,
		sum(product_weight_g) as product_weight_g
	from magist.order_items a
	left join magist.products b
		on a.product_id = b.product_id
	group by 1
	) b
    on a.order_id = b.order_id
group by 1
order by 1
;
-- Datamart
drop table if exists order_reviews2;
create table order_reviews2 as
select *
from (
select 
	row_number() over (partition by order_id order by review_score) as rn,
    order_reviews.*
from order_reviews
) a
where a.rn = 1
;
drop table if exists order_info;
create table order_info as
select 
	o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
	DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) AS delivery_days,
    case 
		when DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) > 0 then 1
        else 0
	end
    as delay_flg,
    sum(oi.price) as order_amt,
    max(oi.price) as max_item_price,
    count(oi.price) as number_of_items,
    sum(oi.freight_value) as order_freight_value
from magist.orders o
left join magist.order_items oi
	on o.order_id = oi.order_id
group by 1,2,3,4,5,6
order by 1
;
drop table if exists order_info2;
create table order_info2 as
select 
	oin.*,
    min(oi.product_id) as product_id
from order_info oin
left join order_items oi
	on oin.order_id = oi.order_id
		and oin.max_item_price = oi.price
group by 1,2,3,4,5,6,7,8,9,10
;
drop table if exists order_info3;
create table order_info3 as
select 
	oin.*,
    op.payment_value,
    -- g.city,
    g.state,
    g.lat,
    g.lng,
    p.product_weight_g,
    pcnt.product_category_name_english,
    case 
		when pcnt.product_category_name_english in ('computers_accessories',
			'telephony',
			'computers',
			'electronics',
			'audio') then 'Tech'
		else 'Non-tech' 
        end 
        as new_category_name,
    ore.review_score
    -- ore.review_comment_title,
    -- ore.review_comment_message
    
from order_info2 oin
left join (
	select order_id, 
		sum(payment_value) as payment_value 
        from order_payments 
        group by 1) op
	on oin.order_id = op.order_id
left join customers c
	on oin.customer_id = c.customer_id
left join geo g
	on c.customer_zip_code_prefix = g.zip_code_prefix
left join products p
	on p.product_id = oin.product_id
left join product_category_name_translation pcnt
	on pcnt.product_category_name = p.product_category_name
left join order_reviews2 ore
	on ore.order_id = oin.order_id
;
select *
from order_info3
;
select 
	order_status,
    count(*) as cnt,
    avg(order_amt) as order_amt,
	avg(max_item_price) as max_item_price,
    avg(delay_flg) as delay_flg,
    sum(order_amt) as sum_order,
    sum(payment_value) as payment_order,
    sum(order_freight_value) as freight_value,
    sum(order_amt) + sum(order_freight_value) as new_one
from order_info3
group by 1
order by 2 desc
