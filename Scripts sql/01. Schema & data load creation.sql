-- 1. Customers Dataset

CREATE TABLE olist_customers_dataset(
    customer_id varchar(255)  PRIMARY KEY,
    customer_unique_id varchar(255),
    customer_zip_code_prefix varchar(10),
    customer_city varchar(255),
    customer_state varchar(10)
);

-- 2. Geolocation Dataset (No Primary Key as zip codes repeat)

CREATE TABLE olist_geolocation_dataset (
    geolocation_zip_code_prefix varchar(10),
    geolocation_lat decimal(10,8),
    geolocation_lng decimal(11,8),
    geolocation_city varchar(255),
    geolocation_state varchar(2)
);

-- 3. Products Dataset
;
CREATE TABLE olist_products_dataset (
    product_id varchar(255) PRIMARY KEY,
    product_category_name varchar(255),
    product_name_lenght INTEGER,
    product_description_lenght INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER
);

-- 4. Sellers Dataset

CREATE TABLE olist_sellers_dataset (
    seller_id Varchar(255) PRIMARY KEY,
    seller_zip_code_prefix Varchar(10),
    seller_city Varchar(255),
    seller_state Varchar(2)
);

-- 5. Orders Dataset

CREATE TABLE olist_orders_dataset (
    order_id Varchar(255) PRIMARY KEY,
    customer_id Varchar(255),
    order_status Varchar(50),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

-- 6. Order Items Dataset

CREATE TABLE olist_order_items_dataset (
    order_id Varchar(255),
    order_item_id INTEGER,
    product_id Varchar(255),
    seller_id Varchar(255),
    shipping_limit_date TIMESTAMP,
    price decimal(10,2),
    freight_value decimal(10,2),
    primary key(order_id,order_item_id)
);

-- 7. Order Payments Dataset

CREATE TABLE olist_order_payments_dataset (
    order_id Varchar(255),
    payment_sequential INTEGER,
    payment_type Varchar(255),
    payment_installments INTEGER,
    payment_value Decimal(10,2),
    index(order_id)
);

-- 8. Order Reviews Dataset

CREATE TABLE olist_order_reviews_dataset (
    review_id varchar(255) primary key,
    order_id varchar(255),foreign key(order_id)  REFERENCES olist_orders_dataset(order_id),
    review_score INTEGER,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

-- 9. Product Category Name Translation

CREATE TABLE product_category_name_translation (
    product_category_name varchar(255) primary key,
    product_category_name_english Varchar(255)
    );
    
    -- Link Orders to Customers
ALTER TABLE olist_orders_dataset
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id) REFERENCES olist_customers_dataset(customer_id);

-- Link Order Items to Orders, Products, and Sellers
ALTER TABLE olist_order_items_dataset
ADD CONSTRAINT fk_items_orders
FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id),
ADD CONSTRAINT fk_items_products
FOREIGN KEY (product_id) REFERENCES olist_products_dataset(product_id),
ADD CONSTRAINT fk_items_sellers
FOREIGN KEY (seller_id) REFERENCES olist_sellers_dataset(seller_id);

-- Link Order Payments to Orders
ALTER TABLE olist_order_payments_dataset
ADD CONSTRAINT fk_payments_orders
FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id);

set global local_infile = 1 ;
load data local infile 'E:/sagar material/Source/archive/olist_customers_dataset.csv'
into table olist_customers_dataset fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

load data local infile 'E:/sagar material/Source/archive/olist_geolocation_dataset.csv'
into table olist_geolocation_dataset fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

load data local infile 'E:/sagar material/Source/archive/olist_products_dataset.csv'
into table olist_products_dataset fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

load data local infile 'E:/sagar material/Source/archive/olist_sellers_dataset.csv'
into table olist_sellers_dataset fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

load data local infile 'E:/sagar material/Source/archive/olist_order_items_dataset.csv'
into table olist_order_items_dataset fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

load data local infile 'E:/sagar material/Source/archive/product_category_name_translation.csv'
into table product_category_name_translation fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

load data local infile 'E:/sagar material/Source/archive/olist_orders_dataset.csv'
into table olist_orders_dataset fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

load data local infile 'E:/sagar material/Source/archive/olist_order_reviews_dataset.csv'
into table olist_order_reviews_dataset fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

load data local infile 'E:/sagar material/Source/archive/olist_order_payments_dataset.csv'
into table olist_order_payments_dataset fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows;