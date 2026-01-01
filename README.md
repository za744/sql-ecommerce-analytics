## Project Overview ##

This project analyzes a fictional e-commerce transactions dataset using PostgreSQL to extract actionable business insights. The analysis focuses on customer behavior, product performance, revenue trends, discount impact, and category-level rankings.

The goal of this project is to demonstrate practical SQL skills used in real-world analytics and business intelligence roles.

## Dataset Overview ##

Source: Generated e-commerce transaction data

Rows: ~250 transactions

Time Range: YYYY-MM-DD to YYYY-MM-DD

### Key Columns: ###
- order_id, order_date, order_status
  
- customer_id, customer_name, customer_segment

- product_name, category

- quantity, unit_price, discount_pct

### SQL Techniques Used ###

- Aggregate functions (SUM, AVG, COUNT, MIN, MAX)

- Filtering and grouping (WHERE, GROUP BY, HAVING)

- Subqueries for order-level metrics

- Window functions (RANK, DENSE_RANK)

- Date functions (DATE_TRUNC)

- Business logic filtering (completed vs cancelled orders)

## Key Findings ##

- Revenue is highly concentrated among a small subset of customers, with top customers contributing a disproportionate share of total net revenue. This could also be slightly skewed due to the fact that there are only 10 distinct customers in the dataset.


- Only a handful of products and categories generate the majority of revenue. This suggests that business performance depends heavily on a small subset of high-performing products rather than being spread evenly across all items.

- Discounts materially reduce net revenue and vary significantly by category, suggesting opportunities to optimize pricing strategy.
 - Total gross revenue before discounts was $260,150 while total net revenue after discounts was $237,887.4494 which means that around $22,262.5 was lost to discounts.

 - Discounts clearly affect revenue, with Electronics having a higher average discount (about 8.5%) compared to Furniture (about 7.9%). Since Electronics products also tend to have higher prices, this category ends up losing more revenue from discounts overall. This suggests there may be room to improve how        discounts are applied across different categories.

- Average order values are similar across customer segments, with Standard customers showing a slightly higher average order value than Premium customers. This suggests that while segmentation exists, spending behavior per order does not differ as much as expected between segments.

- Revenue shows noticeable variation over time, pointing to potential seasonality.

- Repeat customers represent an important source of revenue, highlighting the value of retention strategies.
