-- SQL Assignment Solutions

-- 1. Write a query to select all data from the Customers table.
SELECT * 
FROM assignment.customers;

-- 2. Write a query to select the total number of products from the Products table.
SELECT COUNT(*) AS total_products
FROM assignment.products;

-- 3. Write a query to select the product name and its price from the Products table where the price is greater than 500.
SELECT product_name, price
FROM assignment.products
WHERE price > 500;

-- 4. Write a query to find the average price of all products from the Products table.
SELECT AVG(price) AS avg_price
FROM assignment.products;

-- 5. Write a query to find the total sales amount from the Sales table.
SELECT SUM(total_amount) AS total_sales
FROM assignment.sales;

-- 6. Write a query to select distinct membership statuses from the Customers table.
SELECT DISTINCT membership_status
FROM assignment.customers;

-- 7. Write a query to concatenate first and last names of all customers and show the result as full_name.
SELECT first_name + ' ' + last_name AS full_name
FROM assignment.customers;

-- 8. Write a query to find all products in the Products table where the category is 'Electronics'.
SELECT *
FROM assignment.products
WHERE category = 'Electronics';

-- 9. Write a query to find the highest price from the Products table.
SELECT MAX(price) AS highest_price
FROM assignment.products;

-- 10. Write a query to count the number of sales for each product from the Sales table.
SELECT product_id, COUNT(*) AS total_sales
FROM assignment.sales
GROUP BY product_id;

-- 11. Write a query to find the total quantity sold for each product from the Sales table.
SELECT product_id, SUM(quantity_sold) AS total_quantity
FROM assignment.sales
GROUP BY product_id;

-- 12. Write a query to find the lowest price of products in the Products table.
SELECT MIN(price) AS lowest_price
FROM assignment.products;

-- 13. Write a query to find customers who have purchased products with a price greater than 1000.
SELECT DISTINCT c.*
FROM assignment.customers c
JOIN assignment.sales s ON c.customer_id = s.customer_id
JOIN assignment.products p ON s.product_id = p.product_id
WHERE p.price > 1000;

-- 14. Write a query to join the Sales and Products tables on product_id, and select the product name and total sales amount.
SELECT p.product_name, s.total_amount
FROM assignment.sales s
JOIN assignment.products p ON s.product_id = p.product_id;

-- 15. Write a query to join the Customers and Sales tables and find the total amount spent by each customer.
SELECT c.customer_id, c.first_name, SUM(s.total_amount) AS total_spent
FROM assignment.customers c
JOIN assignment.sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name;

-- 16. Write a query to join the Customers, Sales, and Products tables, and show each customer's first and last name, product name, and quantity sold.
SELECT c.first_name, c.last_name, p.product_name, s.quantity_sold
FROM assignment.customers c
JOIN assignment.sales s ON c.customer_id = s.customer_id
JOIN assignment.products p ON s.product_id = p.product_id;

-- 17. Write a query to perform a self-join on the Customers table and find all pairs of customers who have the same membership status.
SELECT c1.customer_id, c2.customer_id, c1.membership_status
FROM assignment.customers c1
JOIN assignment.customers c2 
ON c1.membership_status = c2.membership_status
AND c1.customer_id < c2.customer_id;

-- 18. Write a query to join the Sales and Products tables, and calculate the total number of sales for each product.
SELECT p.product_name, COUNT(*) AS total_sales
FROM assignment.sales s
JOIN assignment.products p ON s.product_id = p.product_id
GROUP BY p.product_name;

-- 19. Write a query to find the products in the Products table where the stock quantity is less than 10.
SELECT *
FROM assignment.products
WHERE stock_quantity < 10;

-- 20. Write a query to join the Sales table and the Products table, and find products with sales greater than 5.
SELECT p.product_name, SUM(s.quantity_sold) AS total_qty
FROM assignment.sales s
JOIN assignment.products p ON s.product_id = p.product_id
GROUP BY p.product_name
HAVING SUM(s.quantity_sold) > 5;

-- 21. Write a query to select customers who have purchased products that are either in the 'Electronics' or 'Appliances' category.
SELECT DISTINCT c.*
FROM assignment.customers c
JOIN assignment.sales s ON c.customer_id = s.customer_id
JOIN assignment.products p ON s.product_id = p.product_id
WHERE p.category IN ('Electronics', 'Appliances');

-- 22. Write a query to calculate the total sales amount per product and group the result by product name.
SELECT p.product_name, SUM(s.total_amount) AS total_sales
FROM assignment.sales s
JOIN assignment.products p ON s.product_id = p.product_id
GROUP BY p.product_name;

-- 23. Write a query to join the Sales table with the Customers table and select customers who made a purchase in the year 2023.
SELECT DISTINCT c.*
FROM assignment.customers c
JOIN assignment.sales s ON c.customer_id = s.customer_id
WHERE YEAR(s.sale_date) = 2023;

-- 24. Write a query to find the customers with the highest total sales in 2023.
SELECT TOP 1 c.customer_id, SUM(s.total_amount) AS total_spent
FROM assignment.sales s
JOIN assignment.customers c ON s.customer_id = c.customer_id
WHERE YEAR(s.sale_date) = 2023
GROUP BY c.customer_id
ORDER BY total_spent DESC;

-- 25. Write a query to join the Products and Sales tables and select the most expensive product sold.
SELECT TOP 1 p.product_name, p.price
FROM assignment.products p
JOIN assignment.sales s ON p.product_id = s.product_id
ORDER BY p.price DESC;

-- 26. Write a query to find the total number of customers who have purchased products worth more than 500.
SELECT COUNT(DISTINCT customer_id) AS customers_count
FROM assignment.sales
WHERE total_amount > 500;

-- 27. Write a query to join the Products, Sales, and Customers tables and find the total number of sales made by customers who are in the 'Gold' membership tier.
SELECT COUNT(*) AS total_sales
FROM assignment.sales s
JOIN assignment.customers c ON s.customer_id = c.customer_id
WHERE c.membership_status = 'Gold';

-- 28. Write a query to join the Products and Inventory tables and find all products that have low stock (less than 10).
SELECT p.product_name, i.stock_quantity
FROM assignment.products p
JOIN assignment.inventory i ON p.product_id = i.product_id
WHERE i.stock_quantity < 10;

-- 29. Write a query to find customers who have purchased more than 5 products and show the total quantity of products they have bought.
SELECT customer_id, SUM(quantity_sold) AS total_qty
FROM assignment.sales
GROUP BY customer_id
HAVING SUM(quantity_sold) > 5;

-- 30. Write a query to find the average quantity sold per product.
SELECT AVG(quantity_sold) AS avg_qty
FROM assignment.sales;

-- 31. Write a query to find the number of sales made in the month of December 2023.
SELECT COUNT(*) AS total_sales
FROM assignment.sales
WHERE YEAR(sale_date) = 2023 AND MONTH(sale_date) = 12;

-- 32. Write a query to find the total amount spent by each customer in 2023 and list the customers in descending order.
SELECT c.customer_id, SUM(s.total_amount) AS total_spent
FROM assignment.sales s
JOIN assignment.customers c ON s.customer_id = c.customer_id
WHERE YEAR(s.sale_date) = 2023
GROUP BY c.customer_id
ORDER BY total_spent DESC;

-- 33. Write a query to find all products that have been sold but have less than 5 units left in stock.
SELECT DISTINCT p.product_name
FROM assignment.products p
JOIN assignment.sales s ON p.product_id = s.product_id
JOIN assignment.inventory i ON p.product_id = i.product_id
WHERE i.stock_quantity < 5;

-- 34. Write a query to find the total sales for each product and order the result by the highest sales.
SELECT product_id, SUM(total_amount) AS total_sales
FROM assignment.sales
GROUP BY product_id
ORDER BY total_sales DESC;

-- 35. Write a query to find all customers who bought products within 7 days of their registration date.
SELECT DISTINCT c.*
FROM assignment.customers c
JOIN assignment.sales s ON c.customer_id = s.customer_id
WHERE DATEDIFF(DAY, c.registration_date, s.sale_date) <= 7;

-- 36. Write a query to join the Sales table with the Products table and filter the results by products priced between 100 and 500.
SELECT p.product_name, s.total_amount
FROM assignment.sales s
JOIN assignment.products p ON s.product_id = p.product_id
WHERE p.price BETWEEN 100 AND 500;

-- 37. Write a query to find the most frequent customer who made purchases from the Sales table.
SELECT TOP 1 customer_id, COUNT(*) AS purchase_count
FROM assignment.sales
GROUP BY customer_id
ORDER BY purchase_count DESC;

-- 38. Write a query to find the total quantity of products sold per customer.
SELECT customer_id, SUM(quantity_sold) AS total_qty
FROM assignment.sales
GROUP BY customer_id;

-- 39. Write a query to find the products with the highest stock and lowest stock, and display them together in a single result set.
SELECT product_id, stock_quantity
FROM assignment.inventory
WHERE stock_quantity = (SELECT MAX(stock_quantity) FROM assignment.inventory)
   OR stock_quantity = (SELECT MIN(stock_quantity) FROM assignment.inventory);

-- 40. Write a query to find products whose names contain the word 'Phone' and their total sales.
SELECT p.product_name, SUM(s.total_amount) AS total_sales
FROM assignment.products p
JOIN assignment.sales s ON p.product_id = s.product_id
WHERE p.product_name LIKE '%Phone%'
GROUP BY p.product_name;

-- 41. Write a query to perform an INNER JOIN between Customers and Sales, then display the total sales amount and the product names for customers in the 'Gold' membership status.
SELECT c.first_name, p.product_name, s.total_amount
FROM assignment.customers c
JOIN assignment.sales s ON c.customer_id = s.customer_id
JOIN assignment.products p ON s.product_id = p.product_id
WHERE c.membership_status = 'Gold';

-- 42. Write a query to find the total sales of products by category.
SELECT p.category, SUM(s.total_amount) AS total_sales
FROM assignment.sales s
JOIN assignment.products p ON s.product_id = p.product_id
GROUP BY p.category;

-- 43. Write a query to join the Products table with the Sales table, and calculate the total sales for each product, grouped by month and year.
SELECT p.product_name, YEAR(s.sale_date) AS year, MONTH(s.sale_date) AS month, SUM(s.total_amount) AS total_sales
FROM assignment.sales s
JOIN assignment.products p ON s.product_id = p.product_id
GROUP BY p.product_name, YEAR(s.sale_date), MONTH(s.sale_date);

-- 44. Write a query to join the Sales and Inventory tables and find products that have been sold but still have stock remaining.
SELECT p.product_name, i.stock_quantity
FROM assignment.sales s
JOIN assignment.inventory i ON s.product_id = i.product_id
JOIN assignment.products p ON p.product_id = s.product_id
WHERE i.stock_quantity > 0;

-- 45. Write a query to find the top 5 customers who have made the highest purchases.
SELECT TOP 5 customer_id, SUM(total_amount) AS total_spent
FROM assignment.sales
GROUP BY customer_id
ORDER BY total_spent DESC;

-- 46. Write a query to calculate the total number of unique products sold in 2023.
SELECT COUNT(DISTINCT product_id) AS total_products
FROM assignment.sales
WHERE YEAR(sale_date) = 2023;

-- 47. Write a query to find the products that have not been sold in the last 6 months.
SELECT *
FROM assignment.products p
WHERE p.product_id NOT IN (
    SELECT product_id
    FROM assignment.sales
    WHERE sale_date >= DATEADD(MONTH, -6, GETDATE())
);

-- 48. Write a query to select the products with a price range between $200 and $800, and find the total quantity sold for each.
SELECT p.product_name, SUM(s.quantity_sold) AS total_qty
FROM assignment.products p
JOIN assignment.sales s ON p.product_id = s.product_id
WHERE p.price BETWEEN 200 AND 800
GROUP BY p.product_name;

-- 49. Write a query to find the customers who spent the most money in the year 2023.
SELECT TOP 1 customer_id, SUM(total_amount) AS total_spent
FROM assignment.sales
WHERE YEAR(sale_date) = 2023
GROUP BY customer_id
ORDER BY total_spent DESC;

-- 50. Write a query to select the products that have been sold more than 100 times and have a price greater than 200.
SELECT p.product_name, SUM(s.quantity_sold) AS total_qty
FROM assignment.products p
JOIN assignment.sales s ON p.product_id = s.product_id
WHERE p.price > 200
GROUP BY p.product_name
HAVING SUM(s.quantity_sold) > 100;
