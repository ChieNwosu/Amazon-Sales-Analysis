-- Table Statement of the first 10 entries
SELECT * FROM amazon
LIMIT 10;

-- 1. What is the overall performance summary of Amazon products?

SELECT
	-- "COUNT" query to add up the total number of products
    COUNT(*) AS total_products,
    COUNT(DISTINCT category) AS unique_categories,
    AVG(rating) AS avg_rating,
    MIN(discounted_price) AS min_price,
    MAX(discounted_price) AS max_price,
    AVG(discounted_price) AS avg_price,
    AVG(discount_percentage) AS avg_discount
FROM 
    amazon;

-- 2. Which categories have the highest and lowest average product ratings?

SELECT 
    category,
    ROUND(AVG(rating), 2) AS avg_rating
FROM 
    amazon
GROUP BY 
    category
ORDER BY 
    avg_rating DESC;

-- 3. What is the distribution of products across categories?

SELECT 
    category,
    COUNT(*) AS num_products
FROM 
    amazon
GROUP BY 
    category
ORDER BY 
    num_products DESC;

-- 4. Which categories offer the highest average discounts?

SELECT 
    category,
    ROUND(AVG(discount_percentage), 2) AS avg_discount_percent
FROM 
    amazon
GROUP BY 
    category
ORDER BY 
    avg_discount_percent DESC;

-- 5. What is the average discounted price and rating per category?
-- (This query is to combine customer feedback and pricing across categories)
SELECT 
    category,
    ROUND(AVG(discounted_price), 2) AS avg_discounted_price,
    ROUND(AVG(rating), 2) AS avg_rating
FROM 
    amazon
GROUP BY 
    category
ORDER BY 
    avg_discounted_price DESC;

-- 6. What percentage of products fall under each category?

SELECT 
    category,
    COUNT(*) AS category_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM amazon), 2) AS category_percentage
FROM 
    amazon
GROUP BY 
    category
ORDER BY 
    category_percentage DESC;


-- 7. Identify high-value deals (products with discount > 50% and high rating).
-- This query is for useful information on targeting marketing or “Top Deal” promotions
SELECT 
    product_name,
    category,
    discounted_price,
    discount_percentage,
    rating
FROM 
    amazon
WHERE 
    discount_percentage > 50 AND rating >= 4
ORDER BY 
    discount_percentage DESC, rating DESC;

-- 8. Which product categories have the most high-rated products (rating >= 4.5)?
-- (This helps identify high-performing categories from a customer satisfaction perspective)

SELECT 
    category,
    COUNT(*) AS high_rated_products
FROM 
    amazon
WHERE 
    rating IS NOT NULL AND rating >= 4.5
GROUP BY 
    category
ORDER BY 
    high_rated_products DESC;

-- 9. Categorize products into pricing tiers and count how many fall into each tier
-- (Exercising the CASE query shows ability to classify data and analyze pricing strategy)

-- 8. Categorize products into pricing tiers and count how many fall into each tier
-- (Adjusted to better match actual price distribution in the dataset)

SELECT
    CASE
        WHEN discounted_price < 1000 THEN 'Budget'
        WHEN discounted_price BETWEEN 1000 AND 3000 THEN 'Standard'
        WHEN discounted_price > 3000 THEN 'Premium'
        ELSE 'Unknown'
    END AS price_tier,
    COUNT(*) AS product_count,
    ROUND(AVG(rating), 2) AS avg_rating_per_tier
FROM
    amazon
WHERE
    discounted_price IS NOT NULL
GROUP BY
    price_tier
ORDER BY
    product_count DESC;

-- 10. What is the average discount percentage for products priced above the average discounted price?
-- (Exercising a common table expression query that explores whether more expensive items tend to get better discounts)

WITH avg_price_cte AS (
    SELECT AVG(discounted_price) AS avg_price
    FROM amazon
    WHERE discounted_price IS NOT NULL
)
SELECT 
    ROUND(AVG(discount_percentage), 2) AS avg_discount_for_expensive_products
FROM 
    amazon, avg_price_cte
WHERE 
    discounted_price IS NOT NULL
    AND discount_percentage IS NOT NULL
    AND discounted_price > avg_price_cte.avg_price;

