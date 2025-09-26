CREATE TABLE public.ecommerce_transactions (
    transaction_id    INT,
    user_name         TEXT,
    age               INT,
    country           TEXT,
    product_category  TEXT,
    purchase_amount   NUMERIC,
    payment_method    TEXT,
    transaction_date  DATE
);

select * from public.ecommerce_transactions;


-- 1. Total Revenue
SELECT SUM(purchase_amount) AS total_revenue
FROM public.ecommerce_transactions;


-- 2. Average Purchase Value
SELECT AVG(purchase_amount) AS avg_purchase_value
FROM public.ecommerce_transactions;


-- 3. Number of Transactions
SELECT COUNT(*) AS total_transactions
FROM public.ecommerce_transactions;


-- 4. Top 5 Countries by Revenue
SELECT country, SUM(purchase_amount) AS total_revenue
FROM public.ecommerce_transactions
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 5;


-- 5. Revenue by Product Category
SELECT product_category, SUM(purchase_amount) AS total_revenue
FROM public.ecommerce_transactions
GROUP BY product_category
ORDER BY total_revenue DESC;


-- 6. Most Popular Payment Method
SELECT payment_method, COUNT(*) AS transaction_count
FROM public.ecommerce_transactions
GROUP BY payment_method
ORDER BY transaction_count DESC;


-- 7. Average Age of Customers
SELECT ROUND(AVG(age), 2) AS avg_customer_age
FROM public.ecommerce_transactions;


-- 8. Revenue by Age Group
SELECT 
    CASE
        WHEN age < 20 THEN 'Below 20'
        WHEN age BETWEEN 20 AND 29 THEN '20s'
        WHEN age BETWEEN 30 AND 39 THEN '30s'
        WHEN age BETWEEN 40 AND 49 THEN '40s'
        ELSE '50+'
    END AS age_group,
    SUM(purchase_amount) AS total_revenue
FROM public.ecommerce_transactions
GROUP BY age_group
ORDER BY total_revenue DESC;


-- 9. Monthly Revenue Trend
SELECT DATE_TRUNC('month', transaction_date) AS month,
       SUM(purchase_amount) AS total_revenue
FROM public.ecommerce_transactions
GROUP BY month
ORDER BY month;


-- 10. Daily Average Sales
SELECT DATE(transaction_date) AS day,
       ROUND(AVG(purchase_amount), 2) AS avg_daily_sales
FROM public.ecommerce_transactions
GROUP BY day
ORDER BY day;


-- 11. Top 10 Customers by Spending
SELECT user_name, SUM(purchase_amount) AS total_spent
FROM public.ecommerce_transactions
GROUP BY user_name
ORDER BY total_spent DESC
LIMIT 10;


-- 12. Percentage Share of Each Country in Revenue
SELECT country,
       ROUND(SUM(purchase_amount) * 100.0 / (SELECT SUM(purchase_amount) FROM public.ecommerce_transactions), 2) AS revenue_percentage
FROM public.ecommerce_transactions
GROUP BY country
ORDER BY revenue_percentage DESC;


-- 13. Most Frequent Shoppers
SELECT user_name, COUNT(*) AS order_count
FROM public.ecommerce_transactions
GROUP BY user_name
ORDER BY order_count DESC
LIMIT 10;


-- 14. Revenue Contribution by Payment Method
SELECT payment_method, SUM(purchase_amount) AS total_revenue
FROM public.ecommerce_transactions
GROUP BY payment_method
ORDER BY total_revenue DESC;


-- 15. Peak Shopping Day
SELECT transaction_date, SUM(purchase_amount) AS daily_revenue
FROM public.ecommerce_transactions
GROUP BY transaction_date
ORDER BY daily_revenue DESC
LIMIT 1;


-- 16. Customer Lifetime Value (CLV) by Country
SELECT
    country,
    SUM(purchase_amount) / COUNT(DISTINCT user_name) AS avg_clv
FROM public.ecommerce_transactions
GROUP BY country
ORDER BY avg_clv DESC;


-- 17. Product Affinity Analysis (Top 5 Co-purchased Categories)
SELECT
    t1.product_category AS category_1,
    t2.product_category AS category_2,
    COUNT(DISTINCT t1.user_name) AS common_customers
FROM public.ecommerce_transactions AS t1
JOIN public.ecommerce_transactions AS t2
    ON t1.user_name = t2.user_name
    AND t1.transaction_id <> t2.transaction_id
    AND t1.product_category < t2.product_category
GROUP BY category_1, category_2
ORDER BY common_customers DESC
LIMIT 5;


-- 18. Monthly Revenue Growth Rate
WITH MonthlyRevenue AS (
    SELECT
        DATE_TRUNC('month', transaction_date) AS month,
        SUM(purchase_amount) AS total_revenue
    FROM public.ecommerce_transactions
    GROUP BY month
)
SELECT
    month,
    total_revenue,
    LAG(total_revenue, 1) OVER (ORDER BY month) AS previous_month_revenue,
    (total_revenue - LAG(total_revenue, 1) OVER (ORDER BY month)) / LAG(total_revenue, 1) OVER (ORDER BY month) * 100 AS mom_growth_rate_percentage
FROM MonthlyRevenue
ORDER BY month;


-- 19. Repeat vs. New Customer Revenue
WITH CustomerFirstPurchase AS (
    SELECT
        user_name,
        MIN(transaction_date) AS first_purchase_date
    FROM public.ecommerce_transactions
    GROUP BY user_name
)
SELECT
    CASE
        WHEN t.transaction_date = cfp.first_purchase_date THEN 'New Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    SUM(t.purchase_amount) AS total_revenue
FROM public.ecommerce_transactions AS t
JOIN CustomerFirstPurchase AS cfp
    ON t.user_name = cfp.user_name
GROUP BY customer_type;


-- 20. Top 5 Product Categories by Revenue within each Country
WITH RankedProductSales AS (
    SELECT
        country,
        product_category,
        SUM(purchase_amount) AS total_revenue,
        ROW_NUMBER() OVER(PARTITION BY country ORDER BY SUM(purchase_amount) DESC) AS rank_in_country
    FROM public.ecommerce_transactions
    GROUP BY country, product_category
)
SELECT
    country,
    product_category,
    total_revenue
FROM RankedProductSales
WHERE rank_in_country <= 5
ORDER BY country, total_revenue DESC;



--- END ---