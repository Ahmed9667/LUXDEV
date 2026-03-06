-- =====================================================
-- SUBQUERY QUESTIONS
-- =====================================================

-- 51. Which customers have spent more than the average spending of all customers?
SELECT c.customer_id, c.first_name, c.last_name,
       SUM(s.total_amount) AS total_spent
FROM assignment.customers c
JOIN assignment.sales s
    ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(s.total_amount) >
(
    SELECT AVG(customer_total)
    FROM (
        SELECT SUM(total_amount) AS customer_total
        FROM assignment.sales
        GROUP BY customer_id
    ) avg_spending
);

-- 52. Which products are priced higher than the average price of all products?
SELECT *
FROM assignment.products
WHERE price >
(
    SELECT AVG(price)
    FROM assignment.products
);

-- 53. Which customers have never made a purchase?
SELECT *
FROM assignment.customers
WHERE customer_id NOT IN
(
    SELECT customer_id
    FROM assignment.sales
);

-- 54. Which products have never been sold?
SELECT *
FROM assignment.products
WHERE product_id NOT IN
(
    SELECT product_id
    FROM assignment.sales
);

-- 55. Which customer made the single most expensive purchase?
SELECT c.customer_id, c.first_name, c.last_name, s.total_amount
FROM assignment.sales s
JOIN assignment.customers c
ON s.customer_id = c.customer_id
WHERE s.total_amount =
(
    SELECT MAX(total_amount)
    FROM assignment.sales
);

-- 56. Which products have total sales greater than the average total sales across all products?
SELECT p.product_id, p.product_name,
       SUM(s.total_amount) total_sales
FROM assignment.sales s
JOIN assignment.products p
ON s.product_id = p.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(s.total_amount) >
(
    SELECT AVG(product_sales)
    FROM
    (
        SELECT SUM(total_amount) product_sales
        FROM assignment.sales
        GROUP BY product_id
    ) avg_sales
);

-- 57. Which customers registered earlier than the average registration date?
SELECT *
FROM assignment.customers
WHERE registration_date <
(
    SELECT AVG(registration_date)
    FROM assignment.customers
);

-- 58. Which products have a price higher than the average price within their own category?
SELECT *
FROM assignment.products p
WHERE price >
(
    SELECT AVG(price)
    FROM assignment.products
    WHERE category = p.category
);

-- 59. Which customers have spent more than the customer with ID = 10?
SELECT c.customer_id, c.first_name, c.last_name,
       SUM(s.total_amount) total_spent
FROM assignment.customers c
JOIN assignment.sales s
ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(s.total_amount) >
(
    SELECT SUM(total_amount)
    FROM assignment.sales
    WHERE customer_id = 10
);

-- 60. Which products have total quantity sold greater than the overall average quantity sold?
SELECT p.product_id, p.product_name,
       SUM(s.quantity_sold) total_qty
FROM assignment.sales s
JOIN assignment.products p
ON s.product_id = p.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(s.quantity_sold) >
(
    SELECT AVG(quantity_sold)
    FROM assignment.sales
);


-- =====================================================
-- COMMON TABLE EXPRESSIONS (CTEs)
-- =====================================================

-- 61. Top 5 highest spending customers
WITH customer_spending AS
(
SELECT customer_id,
       SUM(total_amount) total_spent
FROM assignment.sales
GROUP BY customer_id
)
SELECT TOP 5 *
FROM customer_spending
ORDER BY total_spent DESC;

-- 62. Top 3 most sold products
WITH product_sales AS
(
SELECT product_id,
       SUM(quantity_sold) total_qty
FROM assignment.sales
GROUP BY product_id
)
SELECT TOP 3 *
FROM product_sales
ORDER BY total_qty DESC;

-- 63. Category generating highest revenue
WITH category_sales AS
(
SELECT p.category,
       SUM(s.total_amount) revenue
FROM assignment.sales s
JOIN assignment.products p
ON s.product_id = p.product_id
GROUP BY p.category
)
SELECT *
FROM category_sales
ORDER BY revenue DESC;

-- 64. Customers with more than two purchases
WITH purchase_count AS
(
SELECT customer_id,
       COUNT(*) purchases
FROM assignment.sales
GROUP BY customer_id
)
SELECT *
FROM purchase_count
WHERE purchases > 2;

-- 65. Products sold more than average quantity
WITH product_qty AS
(
SELECT product_id,
       SUM(quantity_sold) total_qty
FROM assignment.sales
GROUP BY product_id
)
SELECT *
FROM product_qty
WHERE total_qty >
(
SELECT AVG(total_qty)
FROM product_qty
);

-- 66. Customers spending above average
WITH spending AS
(
SELECT customer_id,
       SUM(total_amount) total_spent
FROM assignment.sales
GROUP BY customer_id
)
SELECT *
FROM spending
WHERE total_spent >
(
SELECT AVG(total_spent)
FROM spending
);

-- 67. Products ordered by highest revenue
WITH product_revenue AS
(
SELECT product_id,
       SUM(total_amount) revenue
FROM assignment.sales
GROUP BY product_id
)
SELECT *
FROM product_revenue
ORDER BY revenue DESC;

-- 68. Month with highest revenue
WITH monthly_sales AS
(
SELECT MONTH(sale_date) sale_month,
       SUM(total_amount) revenue
FROM assignment.sales
GROUP BY MONTH(sale_date)
)
SELECT *
FROM monthly_sales
ORDER BY revenue DESC;

-- 69. Products purchased by more than three customers
WITH product_customers AS
(
SELECT product_id,
       COUNT(DISTINCT customer_id) customers
FROM assignment.sales
GROUP BY product_id
)
SELECT *
FROM product_customers
WHERE customers > 3;

-- 70. Products sold less than average quantity
WITH product_qty AS
(
SELECT product_id,
       SUM(quantity_sold) total_qty
FROM assignment.sales
GROUP BY product_id
)
SELECT *
FROM product_qty
WHERE total_qty <
(
SELECT AVG(total_qty)
FROM product_qty
);


-- =====================================================
-- WINDOW FUNCTIONS
-- =====================================================

-- 71. Rank customers by spending
SELECT customer_id,
       SUM(total_amount) total_spent,
       RANK() OVER(ORDER BY SUM(total_amount) DESC) rank_spending
FROM assignment.sales
GROUP BY customer_id;

-- 72. Rank products by quantity sold
SELECT product_id,
       SUM(quantity_sold) total_qty,
       RANK() OVER(ORDER BY SUM(quantity_sold) DESC) rank_sales
FROM assignment.sales
GROUP BY product_id;

-- 73. 3rd highest spending customer
SELECT *
FROM
(
SELECT customer_id,
       SUM(total_amount) total_spent,
       RANK() OVER(ORDER BY SUM(total_amount) DESC) rnk
FROM assignment.sales
GROUP BY customer_id
) t
WHERE rnk = 3;

-- 74. 2nd most expensive product
SELECT *
FROM
(
SELECT product_name, price,
       DENSE_RANK() OVER(ORDER BY price DESC) rnk
FROM assignment.products
) t
WHERE rnk = 2;

-- 75. Ranking products within each category
SELECT product_name, category, price,
       RANK() OVER(PARTITION BY category ORDER BY price DESC) category_rank
FROM assignment.products;

-- 76. Ranking customers by number of purchases
SELECT customer_id,
       COUNT(*) purchases,
       RANK() OVER(ORDER BY COUNT(*) DESC) purchase_rank
FROM assignment.sales
GROUP BY customer_id;

-- 77. Running total of sales
SELECT sale_id, sale_date, total_amount,
       SUM(total_amount) OVER(ORDER BY sale_date) running_total
FROM assignment.sales;

-- 78. Previous sale amount
SELECT sale_id, sale_date, total_amount,
       LAG(total_amount) OVER(ORDER BY sale_date) previous_sale
FROM assignment.sales;

-- 79. Next sale amount
SELECT sale_id, sale_date, total_amount,
       LEAD(total_amount) OVER(ORDER BY sale_date) next_sale
FROM assignment.sales;

-- 80. Divide customers into 4 spending groups
SELECT customer_id,
       SUM(total_amount) total_spent,
       NTILE(4) OVER(ORDER BY SUM(total_amount) DESC) spending_group
FROM assignment.sales
GROUP BY customer_id;


-- =====================================================
-- ADVANCED ANALYTICAL QUESTIONS
-- =====================================================

-- 81. Customers buying from multiple categories
SELECT s.customer_id
FROM assignment.sales s
JOIN assignment.products p
ON s.product_id = p.product_id
GROUP BY s.customer_id
HAVING COUNT(DISTINCT p.category) > 1;

-- 82. Purchases within 7 days of registration
SELECT DISTINCT c.customer_id
FROM assignment.customers c
JOIN assignment.sales s
ON c.customer_id = s.customer_id
WHERE s.sale_date <= DATEADD(day,7,c.registration_date);

-- 83. Products with below average stock
SELECT *
FROM assignment.products
WHERE stock_quantity <
(
SELECT AVG(stock_quantity)
FROM assignment.products
);

-- 84. Customers purchasing same product more than once
SELECT customer_id, product_id, COUNT(*) purchases
FROM assignment.sales
GROUP BY customer_id, product_id
HAVING COUNT(*) > 1;

-- 85. Revenue by product category
SELECT p.category,
       SUM(s.total_amount) revenue
FROM assignment.sales s
JOIN assignment.products p
ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;

-- 86. Top 3 most sold products
SELECT TOP 3 product_id,
       SUM(quantity_sold) qty
FROM assignment.sales
GROUP BY product_id
ORDER BY qty DESC;

-- 87. Customers who bought most expensive product
SELECT DISTINCT customer_id
FROM assignment.sales
WHERE product_id =
(
SELECT product_id
FROM assignment.products
WHERE price = (SELECT MAX(price) FROM assignment.products)
);

-- 88. Products purchased by most customers
SELECT product_id,
       COUNT(DISTINCT customer_id) customers
FROM assignment.sales
GROUP BY product_id
ORDER BY customers DESC;

-- 89. Customers with purchases above average sale
SELECT DISTINCT customer_id
FROM assignment.sales
WHERE total_amount >
(
SELECT AVG(total_amount)
FROM assignment.sales
);

-- 90. Customers purchasing above average quantity
SELECT customer_id,
       SUM(quantity_sold) qty
FROM assignment.sales
GROUP BY customer_id
HAVING SUM(quantity_sold) >
(
SELECT AVG(quantity_sold)
FROM assignment.sales
);


-- =====================================================
-- ADVANCED WINDOW + ANALYTICAL PROBLEMS
-- =====================================================

-- 91. Top 10% customers by spending
SELECT *
FROM
(
SELECT customer_id,
       SUM(total_amount) spending,
       NTILE(10) OVER(ORDER BY SUM(total_amount) DESC) bucket
FROM assignment.sales
GROUP BY customer_id
) t
WHERE bucket = 1;

-- 92. Products contributing to top 50% revenue
SELECT *
FROM
(
SELECT product_id,
       SUM(total_amount) revenue,
       SUM(SUM(total_amount)) OVER(ORDER BY SUM(total_amount) DESC) running_rev
FROM assignment.sales
GROUP BY product_id
) t;

-- 93. Customers purchasing in consecutive months
SELECT DISTINCT customer_id
FROM
(
SELECT customer_id,
       MONTH(sale_date) mth,
       LAG(MONTH(sale_date)) OVER(PARTITION BY customer_id ORDER BY sale_date) prev_mth
FROM assignment.sales
) t
WHERE mth = prev_mth + 1;

-- 94. Largest difference between stock and sold quantity
SELECT p.product_id,
       p.stock_quantity,
       SUM(s.quantity_sold) sold_qty,
       ABS(p.stock_quantity - SUM(s.quantity_sold)) diff
FROM assignment.products p
JOIN assignment.sales s
ON p.product_id = s.product_id
GROUP BY p.product_id, p.stock_quantity
ORDER BY diff DESC;

-- 95. Customers spending above their membership average
SELECT *
FROM
(
SELECT c.customer_id,
       c.membership_status,
       SUM(s.total_amount) spending,
       AVG(SUM(s.total_amount)) OVER(PARTITION BY membership_status) avg_tier
FROM assignment.customers c
JOIN assignment.sales s
ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.membership_status
) t
WHERE spending > avg_tier;

-- 96. Products selling above category average
SELECT *
FROM
(
SELECT p.product_id,
       p.category,
       SUM(s.quantity_sold) qty,
       AVG(SUM(s.quantity_sold)) OVER(PARTITION BY category) avg_cat
FROM assignment.sales s
JOIN assignment.products p
ON s.product_id = p.product_id
GROUP BY p.product_id, p.category
) t
WHERE qty > avg_cat;

-- 97. Largest purchase relative to customer spending
SELECT customer_id, MAX(total_amount) largest_purchase
FROM assignment.sales
GROUP BY customer_id;

-- 98. Top 3 products within each category
SELECT *
FROM
(
SELECT p.product_id,
       p.category,
       SUM(s.quantity_sold) qty,
       RANK() OVER(PARTITION BY p.category ORDER BY SUM(s.quantity_sold) DESC) rnk
FROM assignment.sales s
JOIN assignment.products p
ON s.product_id = p.product_id
GROUP BY p.product_id, p.category
) t
WHERE rnk <= 3;

-- 99. Customers tied for highest spending
SELECT *
FROM
(
SELECT customer_id,
       SUM(total_amount) spending,
       RANK() OVER(ORDER BY SUM(total_amount) DESC) rnk
FROM assignment.sales
GROUP BY customer_id
) t
WHERE rnk = 1;

-- 100. Products generating sales every year
SELECT product_id
FROM assignment.sales
GROUP BY product_id
HAVING COUNT(DISTINCT YEAR(sale_date)) =
(
SELECT COUNT(DISTINCT YEAR(sale_date))
FROM assignment.sales
);
