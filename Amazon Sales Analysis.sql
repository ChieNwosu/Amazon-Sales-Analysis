-- ####### Amazon Sales Data Analysis ######
-- Overview of Dataset --
-- The data consists of sales record of over 1K+ Amazon Product's Ratings and Reviews --
-- as per their details listed on the official website of Amazon --

-- Objective of Project --
-- The major aim of this project is to gain insight into the sales data of Amazon --
-- and to understand the different factors that affect sales of the different  --
-------------------------------------------------------------------------------------------------------

-- Data Wrangling--
CREATE TABLE amazon (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(100),
    discounted_price DECIMAL(10, 2),
    actual_price DECIMAL(10, 2),
    discount_percentage DECIMAL(5, 2),
    rating DECIMAL(3, 1),
    rating_count INT,
    about_product TEXT,
    user_id VARCHAR(50),
    user_name VARCHAR(100),
    review_id VARCHAR(50),
    review_title VARCHAR(255),
    review_content TEXT,
    img_link VARCHAR(255),
    product_link VARCHAR(255)
);

-- Table Statement
SELECT * FROM amazon
LIMIT 10;
-- This query displays the first 10 rows from the amazon table to preview the data structure and contents

-- 1. What is the overall performance summary of Amazon products?

SELECT
    COUNT(*) AS total_products,
    -- Counts the total number of products in the dataset
    
    COUNT(DISTINCT category) AS unique_categories,
    -- Counts how many different product categories exist without duplicates
    
    AVG(rating) AS avg_rating,
    -- Calculates the average customer rating across all products
    
    MIN(discounted_price) AS min_price,
    -- Finds the lowest discounted price available
    
    MAX(discounted_price) AS max_price,
    -- Finds the highest discounted price available
    
    AVG(discounted_price) AS avg_price,
    -- Calculates the average discounted price across all products
    
    AVG(discount_percentage) AS avg_discount
    -- Calculates the average discount percentage across all products
FROM 
    amazon;

-- 2. Which categories have the highest and lowest average product ratings?

SELECT 
    category,
    ROUND(AVG(rating), 2) AS avg_rating
    -- Calculates the average rating for each category and rounds to 2 decimal places
FROM 
    amazon
GROUP BY 
    category
    -- Groups the results by product category
ORDER BY 
    avg_rating DESC;
    -- Sorts results from highest to lowest average rating

-- 3. What is the distribution of products across categories?

SELECT 
    category,
    COUNT(*) AS num_products
    -- Counts how many products exist in each category
FROM 
    amazon
GROUP BY 
    category
    -- Groups the results by product category
ORDER BY 
    num_products DESC;
    -- Sorts results to show categories with most products first

-- 4. Which categories offer the highest average discounts?

SELECT 
    category,
    ROUND(AVG(discount_percentage), 2) AS avg_discount_percent
    -- Calculates the average discount percentage by category, rounded to 2 decimal places
FROM 
    amazon
GROUP BY 
    category
    -- Groups the results by product category
ORDER BY 
    avg_discount_percent DESC;
    -- Sorts results to show categories with highest average discounts first

-- 5. What is the average discounted price and rating per category?
-- (This query combines customer feedback and pricing across categories)

SELECT 
    category,
    ROUND(AVG(discounted_price), 2) AS avg_discounted_price,
    -- Calculates the average discounted price per category, rounded to 2 decimal places
    
    ROUND(AVG(rating), 2) AS avg_rating
    -- Calculates the average customer rating per category, rounded to 2 decimal places
FROM 
    amazon
GROUP BY 
    category
    -- Groups the results by product category
ORDER BY 
    avg_discounted_price DESC;
    -- Sorts results from highest to lowest average discounted price

-- 6. What percentage of products fall under each category?

SELECT 
    category,
    COUNT(*) AS category_count,
    -- Counts the number of products in each category
    
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM amazon), 2) AS category_percentage
    -- Calculates what percentage of total products each category represents
    -- Uses a subquery to get the total count of products
FROM 
    amazon
GROUP BY 
    category
    -- Groups the results by product category
ORDER BY 
    category_percentage DESC;
    -- Sorts results to show categories with highest percentage first

-- 7. Identify high-value deals (products with discount > 50% and high rating).
-- This query is useful for targeting marketing or "Top Deal" promotions

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
    -- Filters to only include products with more than 50% discount and rating of 4 or higher
ORDER BY 
    discount_percentage DESC, rating DESC;
    -- Sorts by highest discount first, then by highest rating

-- 8. Which product categories have the most high-rated products (rating >= 4.5)?
-- (This helps identify high-performing categories from a customer satisfaction perspective)

SELECT 
    category,
    COUNT(*) AS high_rated_products
    -- Counts how many highly-rated products exist in each category
FROM 
    amazon
WHERE 
    rating IS NOT NULL AND rating >= 4.5
    -- Filters to only include products with a rating of 4.5 or higher
    -- Also ensures we don't include products with missing ratings
GROUP BY 
    category
    -- Groups the results by product category
ORDER BY 
    high_rated_products DESC;
    -- Sorts to show categories with most high-rated products first

-- 9. Categorize products into pricing tiers and count how many fall into each tier
-- (Uses CASE statement to classify data and analyze pricing strategy)

SELECT
    CASE
        WHEN discounted_price < 1000 THEN 'Budget'
        WHEN discounted_price BETWEEN 1000 AND 3000 THEN 'Standard'
        WHEN discounted_price > 3000 THEN 'Premium'
        ELSE 'Unknown'
    END AS price_tier,
    -- Creates pricing categories based on discounted price ranges
    
    COUNT(*) AS product_count,
    -- Counts how many products fall into each price tier
    
    ROUND(AVG(rating), 2) AS avg_rating_per_tier
    -- Calculates the average rating for each price tier
FROM
    amazon
WHERE
    discounted_price IS NOT NULL
    -- Ensures we only include products with valid prices
GROUP BY
    price_tier
    -- Groups the results by the price tier categories we created
ORDER BY
    product_count DESC;
    -- Sorts to show the most common price tiers first

-- 10. What is the average discount percentage for products priced above the average discounted price?
-- (Uses a common table expression to explore whether more expensive items tend to get better discounts)

WITH avg_price_cte AS (
    SELECT AVG(discounted_price) AS avg_price
    FROM amazon
    WHERE discounted_price IS NOT NULL
    -- This CTE (Common Table Expression) calculates the overall average price once
)
SELECT 
    ROUND(AVG(discount_percentage), 2) AS avg_discount_for_expensive_products
    -- Calculates the average discount only for products above the average price
FROM 
    amazon, avg_price_cte
    -- Joins the main table with our CTE containing the average price
WHERE 
    discounted_price IS NOT NULL
    AND discount_percentage IS NOT NULL
    -- Ensures we only include products with valid prices and discounts
    AND discounted_price > avg_price_cte.avg_price;
    -- Only includes products priced higher than the overall average

-------------------------------------------------------------------------------------------------------

-- This project presents a comprehensive analysis of Amazon sales data using SQL queries --
-- The analysis extracts key findings about product performance, store operations, customer behavior, and sales patterns. --

-- ##### Key Findings ##### --

-- ##### Product Analysis #####  --

-- Highest Sales Product Line: Electronic Accessories (Units Sold: 971) --
-- Highest Revenue Product Line: Food and Beverages ($ 56,144.96)-- 
-- Lowest Sales Product Line: Health and Beauty (Units Sold: 854) -- 
-- Lowest Revenue Product Line: Health and Beauty ($ 49,193.84) -- 

-- ##### Sales Analysis #####  --

-- Month With Highest Revenue: January ($ 116,292.11) --
-- City & Branch With Highest Revenue: Naypyitaw[C] ($ 110,568.86) -- 
-- Month With Lowest Revenue: February ($ 97,219.58) -- 
-- City & Branch With Lowest Revenue: Mandalay[B] ($ 106,198.00) --
-- Peak Sales Time: Afternoon --
-- Peak Sales Day: Saturday --

-- ##### Customer Analysis #####  --

-- Most Predominant Gender: Female -- 
-- Most Predominant Customer Type: Member --
-- Highest Revenue Gender: Female ($ 167,883.26) --
-- Highest Revenue Customer Type: Member ($ 164,223.81) --
-- Most Popular Product Line (Male): Health and Beauty --
-- Most Popular Product Line (Female): Fashion Accessories --
-- Distribution Of Members: Male (240) Female (261) --
-- Sales by Gender: Male (2,641 units) Female (2,869 units) --
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
