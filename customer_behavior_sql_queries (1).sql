-- ============================================================
-- Customer Shopping Behavior Analysis - SQL Queries
-- Project: Customer Shopping Trends Data Analysis
-- Tools: SQL (MySQL / PostgreSQL / MS SQL Server)
-- Dataset: customer_shopping_behavior.csv (3,900 rows, 18 cols)
-- ============================================================

-- ============================================================
-- SECTION 0: TABLE CREATION
-- ============================================================

CREATE TABLE customer_shopping_behavior (
    customer_id         INT PRIMARY KEY,
    age                 INT,
    gender              VARCHAR(10),
    item_purchased      VARCHAR(100),
    category            VARCHAR(50),
    purchase_amount_usd DECIMAL(10, 2),
    location            VARCHAR(100),
    size                VARCHAR(10),
    color               VARCHAR(50),
    season              VARCHAR(20),
    review_rating       DECIMAL(3, 1),
    subscription_status VARCHAR(10),
    payment_method      VARCHAR(50),
    shipping_type       VARCHAR(50),
    discount_applied    VARCHAR(5),
    promo_code_used     VARCHAR(5),
    previous_purchases  INT,
    frequency_of_purchases VARCHAR(50)
);

-- ============================================================
-- SECTION 1: BASIC EXPLORATION
-- ============================================================

-- Q1. Total number of records in the dataset
SELECT COUNT(*) AS total_records
FROM customer_shopping_behavior;

-- Q2. Distinct categories of products
SELECT DISTINCT category
FROM customer_shopping_behavior
ORDER BY category;

-- Q3. Distinct payment methods available
SELECT DISTINCT payment_method
FROM customer_shopping_behavior
ORDER BY payment_method;

-- Q4. Distinct seasons present in the dataset
SELECT DISTINCT season
FROM customer_shopping_behavior;

-- Q5. Overview of age distribution (min, max, avg)
SELECT
    MIN(age)  AS min_age,
    MAX(age)  AS max_age,
    ROUND(AVG(age), 1) AS avg_age
FROM customer_shopping_behavior;

-- ============================================================
-- SECTION 2: REVENUE ANALYSIS
-- ============================================================

-- Q6. Total revenue generated
SELECT
    ROUND(SUM(purchase_amount_usd), 2) AS total_revenue
FROM customer_shopping_behavior;

-- Q7. Total revenue by product category (descending)
SELECT
    category,
    ROUND(SUM(purchase_amount_usd), 2) AS total_revenue,
    COUNT(*)                            AS total_orders
FROM customer_shopping_behavior
GROUP BY category
ORDER BY total_revenue DESC;

-- Q8. Average purchase amount by category
SELECT
    category,
    ROUND(AVG(purchase_amount_usd), 2) AS avg_purchase
FROM customer_shopping_behavior
GROUP BY category
ORDER BY avg_purchase DESC;

-- Q9. Revenue by season
SELECT
    season,
    ROUND(SUM(purchase_amount_usd), 2)  AS total_revenue,
    COUNT(*)                             AS total_orders,
    ROUND(AVG(purchase_amount_usd), 2)  AS avg_order_value
FROM customer_shopping_behavior
GROUP BY season
ORDER BY total_revenue DESC;

-- Q10. Top 10 items purchased by revenue
SELECT
    item_purchased,
    ROUND(SUM(purchase_amount_usd), 2) AS total_revenue,
    COUNT(*)                            AS purchase_count
FROM customer_shopping_behavior
GROUP BY item_purchased
ORDER BY total_revenue DESC
LIMIT 10;

-- Q11. Revenue by location (top 10 states)
SELECT
    location,
    ROUND(SUM(purchase_amount_usd), 2) AS total_revenue,
    COUNT(*)                            AS total_orders
FROM customer_shopping_behavior
GROUP BY location
ORDER BY total_revenue DESC
LIMIT 10;

-- ============================================================
-- SECTION 3: GENDER-BASED ANALYSIS
-- ============================================================

-- Q12. Total revenue and order count by gender
SELECT
    gender,
    COUNT(*)                            AS total_orders,
    ROUND(SUM(purchase_amount_usd), 2)  AS total_revenue,
    ROUND(AVG(purchase_amount_usd), 2)  AS avg_purchase_amount
FROM customer_shopping_behavior
GROUP BY gender
ORDER BY total_revenue DESC;

-- Q13. Most popular product categories by gender
SELECT
    gender,
    category,
    COUNT(*) AS purchase_count,
    ROUND(SUM(purchase_amount_usd), 2) AS revenue
FROM customer_shopping_behavior
GROUP BY gender, category
ORDER BY gender, purchase_count DESC;

-- Q14. Average review rating by gender
SELECT
    gender,
    ROUND(AVG(review_rating), 2) AS avg_review_rating
FROM customer_shopping_behavior
GROUP BY gender;

-- ============================================================
-- SECTION 4: SEASONAL TRENDS
-- ============================================================

-- Q15. Revenue by season and category
SELECT
    season,
    category,
    ROUND(SUM(purchase_amount_usd), 2) AS total_revenue,
    COUNT(*) AS order_count
FROM customer_shopping_behavior
GROUP BY season, category
ORDER BY season, total_revenue DESC;

-- Q16. Most purchased items per season
SELECT
    season,
    item_purchased,
    COUNT(*) AS purchase_count
FROM customer_shopping_behavior
GROUP BY season, item_purchased
ORDER BY season, purchase_count DESC;

-- Q17. Average purchase amount by season and gender
SELECT
    season,
    gender,
    ROUND(AVG(purchase_amount_usd), 2) AS avg_purchase
FROM customer_shopping_behavior
GROUP BY season, gender
ORDER BY season, gender;

-- ============================================================
-- SECTION 5: SUBSCRIPTION BEHAVIOR
-- ============================================================

-- Q18. Revenue split between subscribed and non-subscribed customers
SELECT
    subscription_status,
    COUNT(*)                            AS customer_count,
    ROUND(SUM(purchase_amount_usd), 2)  AS total_revenue,
    ROUND(AVG(purchase_amount_usd), 2)  AS avg_purchase_amount
FROM customer_shopping_behavior
GROUP BY subscription_status;

-- Q19. Promo code usage rate among subscribers vs non-subscribers
SELECT
    subscription_status,
    promo_code_used,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY subscription_status), 2) AS percentage
FROM customer_shopping_behavior
GROUP BY subscription_status, promo_code_used
ORDER BY subscription_status, promo_code_used;

-- Q20. Frequency of purchases by subscription status
SELECT
    subscription_status,
    frequency_of_purchases,
    COUNT(*) AS customer_count
FROM customer_shopping_behavior
GROUP BY subscription_status, frequency_of_purchases
ORDER BY subscription_status, customer_count DESC;

-- ============================================================
-- SECTION 6: DISCOUNT & PROMO CODE ANALYSIS
-- ============================================================

-- Q21. Average purchase amount: discount applied vs not applied
SELECT
    discount_applied,
    COUNT(*)                            AS total_orders,
    ROUND(SUM(purchase_amount_usd), 2)  AS total_revenue,
    ROUND(AVG(purchase_amount_usd), 2)  AS avg_purchase_amount
FROM customer_shopping_behavior
GROUP BY discount_applied;

-- Q22. Promo code usage impact on revenue
SELECT
    promo_code_used,
    COUNT(*)                            AS total_orders,
    ROUND(SUM(purchase_amount_usd), 2)  AS total_revenue,
    ROUND(AVG(purchase_amount_usd), 2)  AS avg_purchase_amount
FROM customer_shopping_behavior
GROUP BY promo_code_used;

-- Q23. Discount application rate by category
SELECT
    category,
    SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) AS discounted_orders,
    COUNT(*) AS total_orders,
    ROUND(SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS discount_rate_pct
FROM customer_shopping_behavior
GROUP BY category
ORDER BY discount_rate_pct DESC;

-- ============================================================
-- SECTION 7: PAYMENT METHOD ANALYSIS
-- ============================================================

-- Q24. Revenue and order count by payment method
SELECT
    payment_method,
    COUNT(*)                            AS total_orders,
    ROUND(SUM(purchase_amount_usd), 2)  AS total_revenue,
    ROUND(AVG(purchase_amount_usd), 2)  AS avg_purchase_amount
FROM customer_shopping_behavior
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- Q25. Most popular payment method by category
SELECT
    category,
    payment_method,
    COUNT(*) AS usage_count
FROM customer_shopping_behavior
GROUP BY category, payment_method
ORDER BY category, usage_count DESC;

-- Q26. Payment method preference by gender
SELECT
    gender,
    payment_method,
    COUNT(*) AS count
FROM customer_shopping_behavior
GROUP BY gender, payment_method
ORDER BY gender, count DESC;

-- ============================================================
-- SECTION 8: CUSTOMER SEGMENTATION
-- ============================================================

-- Q27. Customer age group segmentation by revenue
SELECT
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS age_group,
    COUNT(*)                            AS customer_count,
    ROUND(SUM(purchase_amount_usd), 2)  AS total_revenue,
    ROUND(AVG(purchase_amount_usd), 2)  AS avg_purchase
FROM customer_shopping_behavior
GROUP BY age_group
ORDER BY age_group;

-- Q28. High-value customers (top 10 by total spend)
SELECT
    customer_id,
    age,
    gender,
    location,
    previous_purchases,
    ROUND(SUM(purchase_amount_usd), 2) AS total_spent
FROM customer_shopping_behavior
GROUP BY customer_id, age, gender, location, previous_purchases
ORDER BY total_spent DESC
LIMIT 10;

-- Q29. Customer purchase frequency distribution
SELECT
    frequency_of_purchases,
    COUNT(*) AS customer_count,
    ROUND(AVG(purchase_amount_usd), 2) AS avg_purchase,
    ROUND(SUM(purchase_amount_usd), 2) AS total_revenue
FROM customer_shopping_behavior
GROUP BY frequency_of_purchases
ORDER BY customer_count DESC;

-- Q30. Customers with previous purchases > 30 (loyal customers)
SELECT
    COUNT(*) AS loyal_customers,
    ROUND(AVG(purchase_amount_usd), 2) AS avg_purchase,
    ROUND(SUM(purchase_amount_usd), 2) AS total_revenue
FROM customer_shopping_behavior
WHERE previous_purchases > 30;

-- ============================================================
-- SECTION 9: SHIPPING & SIZE ANALYSIS
-- ============================================================

-- Q31. Revenue by shipping type
SELECT
    shipping_type,
    COUNT(*)                            AS order_count,
    ROUND(SUM(purchase_amount_usd), 2)  AS total_revenue,
    ROUND(AVG(purchase_amount_usd), 2)  AS avg_purchase
FROM customer_shopping_behavior
GROUP BY shipping_type
ORDER BY total_revenue DESC;

-- Q32. Most popular sizes purchased
SELECT
    size,
    COUNT(*) AS purchase_count,
    ROUND(SUM(purchase_amount_usd), 2) AS total_revenue
FROM customer_shopping_behavior
GROUP BY size
ORDER BY purchase_count DESC;

-- ============================================================
-- SECTION 10: REVIEW RATING ANALYSIS
-- ============================================================

-- Q33. Average review rating by category
SELECT
    category,
    ROUND(AVG(review_rating), 2) AS avg_rating,
    COUNT(*) AS total_reviews
FROM customer_shopping_behavior
GROUP BY category
ORDER BY avg_rating DESC;

-- Q34. Review rating distribution
SELECT
    review_rating,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customer_shopping_behavior), 2) AS percentage
FROM customer_shopping_behavior
GROUP BY review_rating
ORDER BY review_rating;

-- Q35. Items with highest average review rating (min 20 reviews)
SELECT
    item_purchased,
    ROUND(AVG(review_rating), 2) AS avg_rating,
    COUNT(*) AS review_count
FROM customer_shopping_behavior
GROUP BY item_purchased
HAVING COUNT(*) >= 20
ORDER BY avg_rating DESC
LIMIT 10;
