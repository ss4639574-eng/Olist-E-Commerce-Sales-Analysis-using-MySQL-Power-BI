 -- Eda --
 -- 1. Total rows in sales --
  select count(*) from bi_fact_sales;
  
  -- 2. Total distinct orders --
  select count(distinct order_id) from bi_fact_sales;
  
  -- 3. Total customers --
  select count(distinct customer_unique_id) from bi_fact_sales;
  
  -- 4. Total products sold --
  
  select count(distinct product_id) from bi_fact_sales;
  
  -- 5. order status Distribution --
  
  select order_status,count(*) as total_orders
  from bi_fact_sales
  group by order_status;
 
  -- 6. Orders by month --
  
  select purchase_month,count(*) as total_orders
  from bi_fact_sales
  group by purchase_month
  order by purchase_month desc;
  
  -- 7. Total Revenue --
  
  select sum(price + freight_value) as total_revenue
  from bi_fact_sales;
  
  -- 8. average delivery days --
  
  select avg(delivery_days) from bi_fact_sales;
  
  -- 9. Late delivery count --
  
  select count(*) from bi_fact_sales
  where is_late = 1 ;
  
  -- 10. Review score distribution --
  
  select review_score, count(*) as total_reviews
  from bi_fact_sales
  group by review_score;
  
  -- 11. Monthly revenue trend --
  
  select purchase_month,sum(price + freight_value) as revenue
  from bi_fact_sales
  group by purchase_month
  order by revenue desc;
  
  -- 12 Revenue by category --
  
  select category,sum(price + freight_value) as revenue
  from bi_fact_sales
  group by category
  order by revenue desc;
  
  -- 13. Revenue by state --
  
  select customer_state,sum(price + freight_value) as revenue
  from bi_fact_sales
  group by customer_state
  order by revenue desc;
  
  -- 14. Top 10 products --
  
  select product_id,count(*) as total_sales
  from bi_fact_sales
  group by product_id
  order by total_sales desc
  limit 10;
  
  -- 15. top categories by orders --
  
  select category, count(*) as total_orders
  from bi_fact_sales
  group by category
  order by total_orders desc;
  
  -- 16. average review score by category --
  
  select category,avg(review_score) as avg_review
  from bi_fact_sales
  group by category
  order by avg_review desc;
  
  -- 17. Payment type usage --
  
  select payment_type,count(*) as total_orders
  from bi_fact_sales
  group by payment_type;
  
  -- 18. Payment installment analysis --
  
  select payment_installments,count(*) as total_orders
  from bi_fact_sales
  group by payment_installments;
  
  -- 19. seller revenue --
  
  select seller_state,sum(price + freight_value) as revenue
  from bi_fact_sales
  group by seller_state
  order by revenue desc;
  
  -- 20. Customer orders by city --
  
  select customer_city,count(*) as orders
  from bi_fact_sales
  group by customer_city
  order by orders desc
  limit 10;
  
  -- 21. average freight value --
  
  select avg(freight_value) from bi_fact_sales;
  
  -- 22. Revenue by seller city --
  
  select seller_city,sum(price + freight_value) as revenue
  from bi_fact_sales
  group by seller_city
  order by revenue desc
  limit 10; 
  
  -- 23. Late delivery % --
  
  select round(sum(is_late)/ count(*) * 100,2)
  as late_delivery_percent
  from bi_fact_sales;
  
  -- 24. Revenue vs delivery time --
  
  select delivery_days,sum(price + freight_value) as revenue
  from bi_fact_sales
  group by delivery_days
  order by delivery_days;
  
  -- 25. Orders with high installments --

select count(*) from bi_fact_sales
where payment_installments >= 6;
  -- 26. Repeat customers --
  
  select customer_unique_id,count(order_id) as total_orders
  from bi_fact_sales
  group by customer_unique_id
  having count(order_id) > 1 ;
  
  -- 27. average order value --
  
  select avg(price + freight_value) as avg_order_value
  from bi_fact_sales;
  
  -- 28. Top revenue months --
  
  select purchase_month,sum(price + freight_value) as revenue
  from bi_fact_sales
  group by purchase_month
  order by revenue desc
  limit 5;
  
  -- 29. category with highest freight --
  
  select category,
  avg(freight_value) as avg_freight
  from bi_fact_sales
  group by category
  order by avg_freight desc;
  
  -- 30. Seller performance by orders --
  
  select seller_id,
  count(*) as total_orders
  from bi_fact_sales
  group by seller_id
  order by total_orders desc
  limit 10;
  
  -- 31. Late delivery by state --
  
  select customer_state,
  sum(is_late) as late_orders
  from bi_fact_sales
  group by customer_state
  order by late_orders desc;
  
  -- 32. Review vs delivery delay --
  
  select is_late,
  avg(review_score) as avg_review
  from bi_fact_sales
  group by is_late;