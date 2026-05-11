-- VIEWS--

CREATE OR REPLACE VIEW bi_dim_product AS
SELECT
  p.product_id,
  COALESCE(t.product_category_name_english, p.product_category_name) AS category,
  p.product_weight_g,
  p.product_length_cm,
  p.product_height_cm,
  p.product_width_cm,
  (p.product_length_cm * p.product_height_cm * p.product_width_cm) AS volume_cm3
FROM olist_products_dataset p
LEFT JOIN product_category_name_translation t
  ON t.product_category_name = p.product_category_name;


CREATE OR REPLACE VIEW bi_fact_review_latest AS
SELECT 
  order_id,
  review_score,
  review_creation_date,
  review_answer_timestamp
FROM (select r.*,row_number() over(partition by r.order_id 
order by r.review_creation_date Desc, r.review_answer_timestamp Desc ) as row_num 
 from olist_order_reviews_dataset r) as ranked_reviews
 WHERE row_num = 1 ;


CREATE OR REPLACE VIEW bi_fact_order AS
SELECT
  o.order_id,
  o.customer_id,
  o.order_status,
  date(o.order_purchase_timestamp) AS purchase_date,
  date_format(o.order_purchase_timestamp,'%Y-%m-01') AS purchase_month,
  Date(o.order_delivered_customer_date) AS delivered_date,
  Date(o.order_estimated_delivery_date) AS estimated_date,
  CASE
    WHEN o.order_status = 'delivered'
     AND o.order_delivered_customer_date IS NOT NULL
    THEN datediff(o.order_delivered_customer_date,o.order_purchase_timestamp)
    ELSE NULL
  END AS delivery_days,
  CASE
    WHEN o.order_status = 'delivered'
     AND o.order_delivered_customer_date IS NOT NULL
     AND o.order_estimated_delivery_date IS NOT NULL
     AND Date(o.order_delivered_customer_date) > Date(o.order_estimated_delivery_date)
    THEN 1 ELSE 0
  END AS is_late,
  c.customer_unique_id,
  c.customer_city,
  c.customer_state
FROM olist_orders_dataset o
JOIN olist_customers_dataset c ON c.customer_id = o.customer_id;


CREATE OR REPLACE VIEW bi_fact_sales AS
SELECT
  oi.order_id,
  oi.order_item_id,
  oi.product_id,
  oi.seller_id,
  Date(oi.shipping_limit_date) AS shipping_limit_date,
  oi.price,
  oi.freight_value,
  fo.customer_id,
  fo.customer_unique_id,
  fo.order_status,
  fo.purchase_date,
  fo.purchase_month,
  fo.delivered_date,
  fo.estimated_date,
  fo.delivery_days,
  fo.is_late,
  fo.customer_city,
  fo.customer_state,
  dp.category,
  r.review_score,
  p.payment_type,
  p.payment_installments,
  p.payment_value,
  s.seller_city,
  s.seller_state
FROM olist_order_items_dataset oi
JOIN bi_fact_order fo ON fo.order_id = oi.order_id
LEFT JOIN bi_dim_product dp ON dp.product_id = oi.product_id
LEFT JOIN bi_fact_review_latest r ON r.order_id = oi.order_id
LEFT JOIN olist_order_payments_dataset p ON p.order_id = oi.order_id
LEFT JOIN olist_sellers_dataset s ON s.seller_id = oi.seller_id;


CREATE OR REPLACE VIEW bi_payments_order AS
 with  payment_ranked as (
 SELECT
  order_id,
  payment_value,
  payment_type,
  payment_installments,
  row_number() over(partition by order_id order by payment_value desc) as rn
  from olist_order_payments_dataset )
  
 select 
 order_id,
 sum(payment_value) as order_payment_value,
 max(payment_installments) as order_payment_installments,
 max(case when rn = 1 then payment_type end) as order_payment_type
 from payment_ranked
 group by order_id;