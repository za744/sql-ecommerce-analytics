--How many total rows are in the dataset?
SELECT COUNT(*) FROM  ecommerce_transactions;

--How many unique orders are there?
SELECT COUNT(DISTINCT order_id) FROM ecommerce_transactions;

--How many unique customers are there?
SELECT COUNT(DISTINCT customer_id) FROM ecommerce_transactions;

--What date range does the dataset cover?
SELECT MIN(order_date), MAX(order_date) FROM ecommerce_transactions et;

--How many orders were cancelled vs completed?
SELECT order_status, COUNT(DISTINCT order_id) AS num_orders FROM ecommerce_transactions
GROUP BY order_status;

--Are there any customers with only cancelled orders?
SELECT customer_name FROM ecommerce_transactions as et
GROUP BY customer_name
HAVING COUNT(CASE WHEN order_status='Cancelled' THEN 1 END) = COUNT(order_id);


--What is the total net revenue from completed orders?
SELECT 
	SUM(quantity * unit_price * (1-discount_pct)) AS Total_Net_Revenue
FROM ecommerce_transactions et
WHERE et.order_status='Completed'; 

--What is the total gross revenue before discounts?
SELECT
	SUM(quantity * unit_price) AS Total_gross_revenue
FROM ecommerce_transactions et
WHERE et.order_status='Completed';

--How much revenue was lost due to discounts?
SELECT
    SUM(quantity * unit_price * discount_pct) AS total_discount_amount
FROM ecommerce_transactions
WHERE order_status = 'Completed';
--What is the average order value (AOV)?
SELECT
	AVG(quantity*unit_price * (1-discount_pct)) AS Average_order_value
FROM ecommerce_transactions et
WHERE et.order_status='Completed';
--What is the average number of items per order?
SELECT
	AVG(quantity) AS Average_items_per_order
FROM ecommerce_transactions et
WHERE et.order_status='Completed';

--What percentage of orders are cancelled?
SELECT 
	COUNT(CASE WHEN order_status='Cancelled' THEN 1 END)::FLOAT / COUNT(CASE WHEN order_status='Completed' THEN 1 END)
	AS cancelled_order_percentage
FROM ecommerce_transactions;

--What is total net revenue by customer?
SELECT 
	customer_name,
	SUM(quantity * unit_price * (1-discount_pct)) AS Total_Net_Revenue
FROM ecommerce_transactions et
WHERE et.order_status='Completed'
GROUP BY customer_name;
--Who are the top 10 customers by lifetime value?
SELECT 
	customer_name,
	SUM(quantity * unit_price * (1-discount_pct)) AS Total_Net_Revenue
FROM ecommerce_transactions et
WHERE et.order_status='Completed'
GROUP BY customer_name
ORDER BY total_net_revenue DESC
LIMIT 10;
--How many orders has each customer placed?
SELECT
	customer_name,
	COUNT(DISTINCT order_id) AS Total_orders_placed
FROM ecommerce_transactions et
WHERE et.order_status='Completed'
GROUP BY customer_name
ORDER BY total_orders_placed DESC;
--How many repeat customers are there?
SELECT COUNT(*) AS repeat_customer_count
FROM (
    SELECT customer_name
    FROM ecommerce_transactions
    WHERE order_status != 'Cancelled'
    GROUP BY customer_name
    HAVING COUNT(order_id) > 1
) AS repeat_customers;
--What is the average order value by customer segment?
SELECT
	customer_segment,
	AVG(order_total) AS average_order_value
FROM (
	SELECT 
		customer_segment,
		order_id,
		SUM(quantity * unit_price * (1-discount_pct)) AS order_total
	FROM ecommerce_transactions et 
	WHERE et.order_status='Completed'
	GROUP BY et.customer_segment, et.order_id
) t

GROUP BY customer_segment;

--What is total net revenue by product?
SELECT product_name, 
SUM(quantity * unit_price * (1-discount_pct)) AS total_net_revenue_product
FROM ecommerce_transactions et
WHERE et.order_status='Completed'
GROUP BY product_name
ORDER BY total_net_revenue_product DESC ;

--What are the top 5 best-selling products by revenue?
SELECT product_name, 
SUM(quantity * unit_price * (1-discount_pct)) AS total_net_revenue_product
FROM ecommerce_transactions et
WHERE et.order_status='Completed'
GROUP BY product_name
ORDER  BY total_net_revenue_product DESC
LIMIT 5;
--What is total revenue by product category?
SELECT category,
SUM(quantity * unit_price * (1-discount_pct)) AS total_net_revenue_category
FROM ecommerce_transactions et
WHERE et.order_status='Completed'
GROUP BY category
ORDER  BY total_net_revenue_category DESC;

--What is the average discount percentage by category?
SELECT category,
AVG(discount_pct) AS average_discount_percentage
FROM ecommerce_transactions et
WHERE et.order_status='Completed'
GROUP BY category
ORDER  BY average_discount_percentage DESC;
--Which category has the highest average order value?
SELECT
	category,
	AVG(order_total) AS average_order_value
FROM (
	SELECT 
		category,
		order_id,
		SUM(quantity * unit_price * (1-discount_pct)) AS order_total
	FROM ecommerce_transactions et 
	WHERE et.order_status='Completed'
	GROUP BY et.category, et.order_id
) t

GROUP BY category
ORDER BY average_order_value DESC
LIMIT 1;

--What is total revenue by month?
SELECT
	TO_CHAR(order_date::DATE, 'Month') AS month,
	SUM(quantity * unit_price * (1-discount_pct)) AS total_net_revenue_month
FROM ecommerce_transactions et
WHERE et.order_status='Completed'
GROUP BY month;

--Rank customers by total net revenue.
SELECT 
	customer_name,
	SUM(quantity * unit_price * (1 - discount_pct)) AS total_net_revenue,
	COUNT(order_id),
    RANK() OVER (ORDER BY SUM(quantity * unit_price * (1 - discount_pct)) DESC) AS RANK 
FROM ecommerce_transactions et
WHERE et.order_status='Completed'
GROUP BY customer_name
ORDER BY "rank";

--Rank products by revenue within each category.
SELECT
    category,
    product_name,
    SUM(quantity * unit_price * (1 - discount_pct)) AS total_net_revenue,
    RANK() OVER (PARTITION BY category ORDER BY SUM(quantity * unit_price * (1 - discount_pct)) DESC) 
    AS revenue_rank
FROM ecommerce_transactions
WHERE order_status = 'Completed'
GROUP BY category, product_name
ORDER BY category, revenue_rank;

--Identify each customer’s first and most recent order date.
SELECT
	customer_name,
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS recent_order_date
FROM ecommerce_transactions et 
GROUP BY customer_name;
