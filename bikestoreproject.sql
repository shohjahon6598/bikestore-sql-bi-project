/* ============================================================
   BIKESTORE BI PROJECT - Step 1: Database, Staging Tables, Final Schema
   ============================================================ */

-- 0. Create database
CREATE DATABASE BikeStoreDB;
GO
USE BikeStoreDB;
GO

/* ============================================================
   STAGING TABLES (loosely typed -> safe target for raw CSV load)
   Everything NVARCHAR so BULK INSERT never chokes on formatting.
   ============================================================ */

CREATE TABLE stg_stores (
    store_id     NVARCHAR(50),
    store_name   NVARCHAR(200),
    phone        NVARCHAR(50),
    email        NVARCHAR(200),
    street       NVARCHAR(200),
    city         NVARCHAR(100),
    state        NVARCHAR(50),
    zip_code     NVARCHAR(20)
);

CREATE TABLE stg_categories (
    category_id   NVARCHAR(50),
    category_name NVARCHAR(200)
);

CREATE TABLE stg_brands (
    brand_id   NVARCHAR(50),
    brand_name NVARCHAR(200)
);

CREATE TABLE stg_customers (
    customer_id NVARCHAR(50),
    first_name  NVARCHAR(100),
    last_name   NVARCHAR(100),
    phone       NVARCHAR(50),
    email       NVARCHAR(200),
    street      NVARCHAR(200),
    city        NVARCHAR(100),
    state       NVARCHAR(50),
    zip_code    NVARCHAR(20)
);

CREATE TABLE stg_staffs (
    staff_id   NVARCHAR(50),
    first_name NVARCHAR(100),
    last_name  NVARCHAR(100),
    email      NVARCHAR(200),
    phone      NVARCHAR(50),
    active     NVARCHAR(10),
    store_id   NVARCHAR(50),
    manager_id NVARCHAR(50)
);

CREATE TABLE stg_products (
    product_id   NVARCHAR(50),
    product_name NVARCHAR(300),
    brand_id     NVARCHAR(50),
    category_id  NVARCHAR(50),
    model_year   NVARCHAR(10),
    list_price   NVARCHAR(50)
);

CREATE TABLE stg_stocks (
    store_id   NVARCHAR(50),
    product_id NVARCHAR(50),
    quantity   NVARCHAR(50)
);

CREATE TABLE stg_orders (
    order_id      NVARCHAR(50),
    customer_id   NVARCHAR(50),
    order_status  NVARCHAR(10),
    order_date    NVARCHAR(50),
    required_date NVARCHAR(50),
    shipped_date  NVARCHAR(50),
    store_id      NVARCHAR(50),
    staff_id      NVARCHAR(50)
);

CREATE TABLE stg_order_items (
    order_id   NVARCHAR(50),
    item_id    NVARCHAR(50),
    product_id NVARCHAR(50),
    quantity   NVARCHAR(50),
    list_price NVARCHAR(50),
    discount   NVARCHAR(50)
);
GO

/* ============================================================
   BULK INSERT TEMPLATE
   Replace 'C:\YourPath\' with the actual folder where your CSVs live
   on the machine running SQL Server. Run one block per file.
   ============================================================ */


BULK INSERT stg_stores       FROM 'C:\Users\Lenovo\Downloads\stores.csv'       WITH (FORMAT='CSV', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='\n', TABLOCK);
BULK INSERT stg_categories   FROM 'C:\Users\Lenovo\Downloads\categories.csv'   WITH (FORMAT='CSV', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='\n', TABLOCK);
BULK INSERT stg_brands       FROM 'C:\Users\Lenovo\Downloads\brands.csv'       WITH (FORMAT='CSV', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='\n', TABLOCK);
BULK INSERT stg_customers    FROM 'C:\Users\Lenovo\Downloads\customers.csv'    WITH (FORMAT='CSV', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='\n', TABLOCK);
BULK INSERT stg_staffs       FROM 'C:\Users\Lenovo\Downloads\staffs.csv'       WITH (FORMAT='CSV', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='\n', TABLOCK);
BULK INSERT stg_products     FROM 'C:\Users\Lenovo\Downloads\products.csv'     WITH (FORMAT='CSV', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='\n', TABLOCK);
BULK INSERT stg_stocks       FROM 'C:\Users\Lenovo\Downloads\stocks.csv'       WITH (FORMAT='CSV', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='\n', TABLOCK);
BULK INSERT stg_orders       FROM 'C:\Users\Lenovo\Downloads\orders.csv'       WITH (FORMAT='CSV', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='\n', TABLOCK);
BULK INSERT stg_order_items  FROM 'C:\Users\Lenovo\Downloads\order_items.csv'  WITH (FORMAT='CSV', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='\n', TABLOCK);
GO

-- Quick sanity check after loading (row counts should match your CSVs)
SELECT 'stores' AS tbl, COUNT(*) AS rows FROM stg_stores
UNION ALL SELECT 'categories', COUNT(*) FROM stg_categories
UNION ALL SELECT 'brands', COUNT(*) FROM stg_brands
UNION ALL SELECT 'customers', COUNT(*) FROM stg_customers
UNION ALL SELECT 'staffs', COUNT(*) FROM stg_staffs
UNION ALL SELECT 'products', COUNT(*) FROM stg_products
UNION ALL SELECT 'stocks', COUNT(*) FROM stg_stocks
UNION ALL SELECT 'orders', COUNT(*) FROM stg_orders
UNION ALL SELECT 'order_items', COUNT(*) FROM stg_order_items;
GO

/* ============================================================
   FINAL NORMALIZED SCHEMA
   Created in parent -> child order so FKs resolve correctly.
   ============================================================ */

CREATE TABLE stores (
    store_id    INT PRIMARY KEY,
    store_name  NVARCHAR(200) NOT NULL,
    phone       NVARCHAR(50),
    email       NVARCHAR(200),
    street      NVARCHAR(200),
    city        NVARCHAR(100),
    state       NVARCHAR(50),
    zip_code    NVARCHAR(20)
);

CREATE TABLE categories (
    category_id   INT PRIMARY KEY,
    category_name NVARCHAR(200) NOT NULL
);

CREATE TABLE brands (
    brand_id   INT PRIMARY KEY,
    brand_name NVARCHAR(200) NOT NULL
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name  NVARCHAR(100) NOT NULL,
    last_name   NVARCHAR(100) NOT NULL,
    phone       NVARCHAR(50)  NULL,         -- some rows are blank in source data
    email       NVARCHAR(200) NOT NULL,
    street      NVARCHAR(200),
    city        NVARCHAR(100),
    state       NVARCHAR(50),
    zip_code    NVARCHAR(20)
);

CREATE TABLE staffs (
    staff_id    INT PRIMARY KEY,
    first_name  NVARCHAR(100) NOT NULL,
    last_name   NVARCHAR(100) NOT NULL,
    email       NVARCHAR(200) NOT NULL,
    phone       NVARCHAR(50),
    active      BIT NOT NULL,
    store_id    INT NOT NULL,
    manager_id  INT NULL,                   -- self-referencing FK, NULL for top manager
    CONSTRAINT FK_staffs_store   FOREIGN KEY (store_id)   REFERENCES stores(store_id),
    CONSTRAINT FK_staffs_manager FOREIGN KEY (manager_id) REFERENCES staffs(staff_id)
);

CREATE TABLE products (
    product_id   INT PRIMARY KEY,
    product_name NVARCHAR(300) NOT NULL,
    brand_id     INT NOT NULL,
    category_id  INT NOT NULL,
    model_year   SMALLINT NOT NULL,
    list_price   DECIMAL(10,2) NOT NULL CHECK (list_price >= 0),
    CONSTRAINT FK_products_brand    FOREIGN KEY (brand_id)    REFERENCES brands(brand_id),
    CONSTRAINT FK_products_category FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE stocks (
    store_id   INT NOT NULL,
    product_id INT NOT NULL,
    quantity   INT NOT NULL CHECK (quantity >= 0),
    PRIMARY KEY (store_id, product_id),
    CONSTRAINT FK_stocks_store   FOREIGN KEY (store_id)   REFERENCES stores(store_id),
    CONSTRAINT FK_stocks_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE orders (
    order_id      INT PRIMARY KEY,
    customer_id   INT NOT NULL,
    order_status  TINYINT NOT NULL,         -- 1=Pending,2=Processing,3=Rejected,4=Completed (verify against your source docs)
    order_date    DATE NOT NULL,
    required_date DATE,
    shipped_date  DATE NULL,                -- NULL if not yet shipped
    store_id      INT NOT NULL,
    staff_id      INT NOT NULL,
    CONSTRAINT FK_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT FK_orders_store    FOREIGN KEY (store_id)    REFERENCES stores(store_id),
    CONSTRAINT FK_orders_staff    FOREIGN KEY (staff_id)    REFERENCES staffs(staff_id)
);

CREATE TABLE order_items (
    order_id   INT NOT NULL,
    item_id    INT NOT NULL,
    product_id INT NOT NULL,
    quantity   INT NOT NULL CHECK (quantity > 0),
    list_price DECIMAL(10,2) NOT NULL CHECK (list_price >= 0),
    discount   DECIMAL(4,2) NOT NULL DEFAULT 0 CHECK (discount BETWEEN 0 AND 1),
    PRIMARY KEY (order_id, item_id),
    CONSTRAINT FK_orderitems_order   FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    CONSTRAINT FK_orderitems_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);
GO

/* ============================================================
   MIGRATE STAGING -> FINAL (parent tables first, same order as above)
   ============================================================ */

INSERT INTO stores (store_id, store_name, phone, email, street, city, state, zip_code)
SELECT CAST(store_id AS INT), store_name, phone, email, street, city, state, zip_code
FROM stg_stores;

INSERT INTO categories (category_id, category_name)
SELECT CAST(category_id AS INT), category_name
FROM stg_categories;

INSERT INTO brands (brand_id, brand_name)
SELECT CAST(brand_id AS INT), brand_name
FROM stg_brands;

INSERT INTO customers (customer_id, first_name, last_name, phone, email, street, city, state, zip_code)
SELECT CAST(customer_id AS INT), first_name, last_name, NULLIF(phone,''), email, street, city, state, zip_code
FROM stg_customers;

INSERT INTO staffs (staff_id, first_name, last_name, email, phone, active, store_id, manager_id)
SELECT CAST(staff_id AS INT), first_name, last_name, email, phone,
       CAST(active AS BIT),
       CAST(store_id AS INT),
       CASE WHEN manager_id IS NULL OR manager_id = '' OR manager_id = 'NULL' THEN NULL ELSE CAST(manager_id AS INT) END
FROM stg_staffs;


INSERT INTO products (product_id, product_name, brand_id, category_id, model_year, list_price)
SELECT CAST(product_id AS INT), product_name, CAST(brand_id AS INT), CAST(category_id AS INT),
       CAST(model_year AS SMALLINT), CAST(list_price AS DECIMAL(10,2))
FROM stg_products;

INSERT INTO stocks (store_id, product_id, quantity)
SELECT CAST(store_id AS INT), CAST(product_id AS INT), CAST(quantity AS INT)
FROM stg_stocks;

INSERT INTO orders (order_id, customer_id, order_status, order_date, required_date, shipped_date, store_id, staff_id)
SELECT CAST(order_id AS INT), CAST(customer_id AS INT), CAST(order_status AS TINYINT),
       CAST(order_date AS DATE),
       CAST(required_date AS DATE),
       CASE WHEN shipped_date IS NULL OR shipped_date = '' OR shipped_date = 'NULL' THEN NULL ELSE CAST(shipped_date AS DATE) END,
       CAST(store_id AS INT), CAST(staff_id AS INT)
FROM stg_orders;

INSERT INTO order_items (order_id, item_id, product_id, quantity, list_price, discount)
SELECT CAST(order_id AS INT), CAST(item_id AS INT), CAST(product_id AS INT),
       CAST(quantity AS INT), CAST(list_price AS DECIMAL(10,2)), CAST(discount AS DECIMAL(4,2))
FROM stg_order_items;
GO

-- Final sanity check
SELECT 'stores' AS tbl, COUNT(*) AS rows FROM stores
UNION ALL SELECT 'categories', COUNT(*) FROM categories
UNION ALL SELECT 'brands', COUNT(*) FROM brands
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'staffs', COUNT(*) FROM staffs
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'stocks', COUNT(*) FROM stocks
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items;
GO



select * 
from orders
select * 
from order_items
select *
from stores



create view vw_StoreSalesSummarry as
select  s.store_name, o.store_id, 
sum(d.list_price*d.quantity*(1-d.discount)) as total_revenue,
COUNT(DISTINCT o.order_id) as total_orders, 
sum(d.list_price*d.quantity*(1-d.discount))/COUNT(DISTINCT o.order_id) as AOV
from orders o
join order_items d
on o.order_id=d.order_id
join stores s
on o.store_id=s.store_id
where o.order_status=4 
group by o.store_id, s.store_name
go
select * from vw_StoreSalesSummarry



select *
from order_items
select *
from products


create view 	vw_TopSellingProducts as 
select o.product_id, p.product_name,
sum(o.quantity*o.list_price*(1-o.discount)) as total_revenue
from order_items o
join products p 
on o.product_id=p.product_id
join orders d
on o.order_id=d.order_id
where d.order_status=4
group by o.product_id, p.product_name
go
select * from vw_TopSellingProducts
order by total_revenue desc




select * from stocks
select * from products
select * from stores

create view 	vw_InventoryStatus as 
select p.product_name, st.store_name, s.quantity,
case 
when s.quantity>0 and s.quantity<=10 then 'kam qolgan'
when s.quantity>10 then 'OK'
when s.quantity=0 then 'qolmagan'
end as stock_status
from stocks s
join stores st
on s.store_id=st.store_id
join products p
on p.product_id=s.product_id

select * from vw_InventoryStatus



select * 
from staffs 
select * from orders 
select * from order_items

create view 	vw_StaffPerformancee as 
select sf.first_name, sf.last_name,
sum(ot.quantity*ot.list_price*(1-ot.discount)) total_contribution,
COUNT(DISTINCT o.order_id) as total_orders
from staffs sf
join orders o 
on sf.staff_id=o.staff_id
join order_items ot
on o.order_id=ot.order_id
where o.order_status=4
group by sf.staff_id, sf.first_name, sf.last_name
go 
select * from vw_StaffPerformancee
order by total_contribution desc


select * from stores
select * from orders
select * from order_items

create view 	vw_RegionalTrends as 
select s.city,  
sum(ot.list_price*ot.quantity*(1-ot.discount)) as total_revenue,
count (distinct o.order_id) as total_orders,
YEAR(o.order_date) as order_year
from stores s
join orders o
on s.store_id=o.store_id
join order_items ot
on o.order_id=ot.order_id
where o.order_status=4
group by s.city, year(o.order_date)

select * from vw_RegionalTrends


select * from order_items
select * from categories
select * from products

create view 	vw_SalesByCategory as
select c.category_name, 
sum(ot.list_price*ot.quantity*(1-ot.discount)) as total_revenue
from products p
join categories c
on p.category_id=c.category_id
join order_items ot
on ot.product_id=p.product_id
join orders o on o.order_id=ot.order_id
where o.order_status=4
group by c.category_id, c.category_name
go
select * from vw_SalesByCategory





---stored procedures 

create procedure 	sp_CalculateStoreKPi
@store_id int
as 
begin
select  s.store_name, o.store_id, 
sum(d.list_price*d.quantity*(1-d.discount)) as total_revenue,
count(distinct o.order_id) as total_orders, 
sum(d.list_price*d.quantity*(1-d.discount))/COUNT(DISTINCT o.order_id) as AOV
from orders o
join order_items d
on o.order_id=d.order_id
join stores s
on o.store_id=s.store_id
where o.order_status=4 
and s.store_id=@store_id
group by o.store_id, s.store_name
end
go
exec sp_CalculateStoreKPi @store_id = 3

---2
create procedure sp_GenerateRestockLisst
@threshold int
as 
begin 
select p.product_name, st.store_name, s.quantity,
case
when s.quantity =0 then 'tugagan'
when s.quantity <= @threshold then 'kam qolgan'
else 'OK'
end as stock_status
from stocks s
join stores st
on s.store_id=st.store_id
join products p
on p.product_id=s.product_id
end 
go 
exec sp_GenerateRestockLisst @threshold=20


create procedure sp_YoYSalesComparison
@year1 INT,
@year2 INT
as
begin
select sum(case when year(o.order_date) = @year1 then d.list_price*d.quantity*(1-d.discount) else 0 end) as year1_revenue,
sum(case when year(o.order_date) = @year2 then d.list_price*d.quantity*(1-d.discount) else 0 end) as year2_revenue,
sum(case when year(o.order_date) = @year2 then d.list_price*d.quantity*(1-d.discount) else 0 end) 
 - sum(case when year(o.order_date) = @year1 then d.list_price*d.quantity*(1-d.discount) else 0 end) as revenue_difference
from orders o
join order_items d on o.order_id = d.order_id
where o.order_status = 4
and year(o.order_date) IN (@year1, @year2)
end 
go
exec sp_YoYSalesComparison @year1=2016, @year2=2017


select * from customers 
select * from products
select * from order_items
select * from orders

create procedure sp_GetCustomerProfilee
@customer_id int
as 
begin

select c.first_name, c.last_name, 
sum(ot.quantity*ot.list_price*(1-ot.discount)) as total_spending,
count(distinct o.order_id) as total_buying,
(select top (1) p.product_name
from order_items ot2
join orders o2 on ot2.order_id = o2.order_id
join products p on ot2.product_id = p.product_id
where o2.customer_id = @customer_id and o2.order_status = 4
group by p.product_name
order by sum(ot2.quantity) desc) as most_bought_product
from customers c 
join orders o on c.customer_id=o.customer_id
join order_items ot on ot.order_id=o.order_id
where o.order_status=4 and c.customer_id=@customer_id
group by c.customer_id, c.first_name, c.last_name
end 
go 

exec sp_GetCustomerProfilee  @customer_id=259



















