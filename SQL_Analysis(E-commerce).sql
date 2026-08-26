select * from customers_sql;
select * from product_sql;
select * from orders_sql;

select 
o.order_id,
o.order_date,
c.customer_id,
c.state,
p.product_name,
p.product_category,
o.quantity,
o.total_amount
from orders_sql o join customers_sql c 
join product_sql p 
on o.product_id=p.product_id;

#TOTAL SALES
select sum(total_amount) as total_sales from orders_sql;

#TOP 5 CUSTOMER
select c.customer_id,
sum(o.total_amount) as total_spent from customers_sql c
join orders_sql o on c.customer_id=o.customer_id
group by
c.customer_id
order by total_spent desc limit 5;

#SALES BY REGION
select 
c.state,
sum(o.total_amount) as total_sales from 
orders_sql o join customers_sql c on o.customer_id=c.customer_id
group by c.state
order by total_sales desc;


#SALES BY PRODUCT
select 
p.product_name,
sum(o.quantity) as unit_sold,
sum(o.total_amount) as revenue
from orders_sql o join product_sql p on o.product_id=p.product_id
group by p.product_name
order by revenue desc;

#SALES BY CATEGORY
select p.product_category,
sum(o.total_amount) as revenue
from orders_sql o join product_sql p on 
 o.product_id=p.product_id
 group by product_category
 order by revenue desc;
 
 #MONTHLY SALES
 select date_format(order_date,'%Y-%m') as month,
 sum(total_amount) as monthly_sales from orders_sql
 group by date_format(order_date,'%Y-%m') order by month;
 
 #CUSTOMERS WHO NEVER ORDERED
 select 
 c.customer_id
 from customers_sql c left join orders_sql o on c.customer_id=o.customer_id
 where o.order_id is null;
 
 #WINDOW FUNCTIONS ANALYSIS
 #RANK CUSTOMERS BY SPENDING
 SELECT
    c.customer_id,
    
    SUM(o.total_amount) AS total_spent,
    RANK() OVER (
        ORDER BY SUM(o.total_amount) DESC
    ) AS customer_rank
FROM customers_sql c
JOIN orders_sql o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id;
 
 
#Rank products within each category
WITH product_sales AS (
    SELECT
        p.product_category,
        p.product_name,
        SUM(o.total_amount) AS revenue
    FROM product_sql p
    JOIN orders_sql o
        ON p.product_id = o.product_id
    GROUP BY p.product_category, p.product_name
)

SELECT
 product_category,
    product_name,
    revenue,
    RANK() OVER (
        PARTITION BY category
        ORDER BY revenue DESC
    ) AS product_rank
FROM product_sales;

# Running total of monthly sales
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(total_amount) AS sales
    FROM orders_sql
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)

SELECT
    month,
    sales,
    SUM(sales) OVER (
        ORDER BY month
    ) AS running_sales
FROM monthly_sales;

