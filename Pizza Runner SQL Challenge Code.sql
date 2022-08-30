-- Create temporary Customer_Orders table
DROP TABLE IF EXISTS customer_orders_1;
SELECT 
  *
INTO customer_orders_1
FROM customer_orders

-- Clean data in the Customer_order Table
update customer_orders_1
set 
exclusions = case exclusions when 'null' then null else exclusions end,
extras = case extras when 'null' then null else extras end;
	
-- Create temporary Runner_Orders table
DROP TABLE IF EXISTS runner_orders_1;
SELECT 
  *
INTO runner_orders_1
FROM runner_orders

-- Clean data in the Runner_Orders Table
update runner_orders_1
set 
pickup_time = case pickup_time when 'null' then null else pickup_time end,
distance = case distance when 'null' then null else distance end,
duration = case duration when 'null' then null else duration end,
cancellation = case cancellation when 'null' then null else cancellation end;

##Case Study Questions
QUESTION 1:
--How many pizzas were ordered?

```sql
SELECT COUNT(order_id) AS num_of_orders
FROM customer_orders_1;
```

**Answer**
14 pizzas were ordered in total.

QUESTION 2
--How many unique customer orders were made?

```sql
SELECT COUNT(DISTINCT(order_id)) AS unique_order_count
FROM customer_orders_1;
```

**Answer**
10 unique customers

QUESTION 3
-How many successful orders were delivered by each runner?

```sql
SELECT runner_id, COUNT(order_id) AS num_of_deliveries
FROM runner_orders_1
WHERE distance IS NOT NULL
GROUP BY runner_id
ORDER BY 2 DESC;

**Answer**
Runner 1 had 4 successful order, runner 2 3 successful order and runner 3 had 1 successful order

QUESTION 4
---How many pizzas were delivered that had both exclusions and extras?

```sql
SELECT count(c.order_id) as delivered_orders_w_exclusions_n_extras
FROM customer_orders_1 c
JOIN runner_orders_1 r
ON c.order_id = r.order_id
WHERE c.exclusions != '' AND c.extras != '' AND r.distance IS NOT NULL;

**Answer**
* Only 1 order with `extras` and `exclusions` was delivered.


QUESTION #5
--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

```sql
SELECT c.customer_id, 
	   SUM(CASE WHEN c.exclusions = '' 
		   			AND c.extras = ''
		   		    THEN 1 ELSE 0 END) AS unchanged,
	   SUM(CASE WHEN c.exclusions != ''
		   			 OR c.extras != '' 
		   			 THEN 1 ELSE 0 END )AS changed
FROM customer_orders_1 c
JOIN runner_orders_1 r
ON c.order_id = r.order_id
WHERE r.distance IS NOT NULL
GROUP BY c.customer_id
ORDER BY c.customer_id;