-- ============================================================
-- Project:  Amazon Sales Analysis
--           SQL Business Questions & Metadata Documentation Case Study
-- Dataset:  Amazon Sales Dataset (Kaggle)
-- Source:   https://www.kaggle.com/datasets/karkavelrajaj/amazon-sales-dataset
-- Scope:    Analysis of 1,400+ Amazon India product listings covering
--           pricing, discounts, customer ratings, and category distribution.
--           Ten business questions are answered using aggregation,
--           filtering, CASE-based segmentation, and a CTE.
-- Purpose:  Demonstrates SQL reasoning, business-question mapping,
--           metadata documentation, and data governance awareness.
-- ============================================================

-- ####### Amazon Sales Data Analysis ######
-- Overview of Dataset --
-- The data consists of sales record of over 1K+ Amazon Product's Ratings and Reviews --
-- as per their details listed on the official website of Amazon --
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

-- ============================================================
-- Data Preview: First 10 Rows
-- Business Question: What does the raw data look like?
-- Purpose:           Confirms the import loaded correctly and previews
--                    the data structure before any analysis begins.
-- Columns Used:      All columns (SELECT *)
-- Expected Result:   A table of 10 rows showing all 16 columns — useful
--                    for verifying column names, data types, and sample values.
-- Governance Note:   Use this preview to spot obvious data quality issues
--                    such as missing values, unexpected formats, or encoding
--                    problems before running aggregation queries.
-- ============================================================

-- Table Statement
SELECT * FROM amazon
LIMIT 10;
-- This query displays the first 10 rows from the amazon table to preview the data structure and contents

-- ============================================================
-- Query 1: Overall Performance Summary
-- Business Question: What is the overall performance summary of Amazon products in this dataset?
-- Purpose:           Provides a high-level snapshot of the dataset — total products,
--                    unique categories, average rating, price range, and average discount.
--                    Establishes a baseline before deeper analysis.
-- Columns Used:      rating, discounted_price, discount_percentage, category
-- Expected Result:   A single summary row with 7 aggregate values:
--                    total_products, unique_categories, avg_rating,
--                    min_price, max_price, avg_price, avg_discount
-- Governance Note:   This query is the first data quality checkpoint. If
--                    total_products is unexpectedly low, or avg_rating falls
--                    outside the 0–5 range, it may indicate import errors or
--                    data integrity issues that should be investigated before
--                    proceeding with category-level analysis.
-- ============================================================

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

-- ============================================================
-- Query 2: Category Average Ratings
-- Business Question: Which product categories have the highest and lowest average customer ratings?
-- Purpose:           Measures average customer satisfaction by category to identify
--                    which categories consistently deliver quality versus those
--                    with lower customer approval.
-- Columns Used:      category, rating
-- Expected Result:   One row per category with columns: category, avg_rating.
--                    Sorted descending — highest-rated categories appear first.
-- Governance Note:   The category column stores a full pipe-delimited hierarchy
--                    (e.g., Electronics|Headphones|WiredHeadphones). Grouping on
--                    this full string means slight variations in category naming
--                    will produce separate rows. Review for inconsistencies if
--                    the number of distinct categories seems unexpectedly high.
-- ============================================================

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

-- ============================================================
-- Query 3: Product Distribution by Category
-- Business Question: How are products distributed across categories in this dataset?
-- Purpose:           Counts the number of products per category to reveal which
--                    categories dominate the catalog and which are underrepresented.
-- Columns Used:      category
-- Expected Result:   One row per category with columns: category, num_products.
--                    Sorted descending — categories with the most products appear first.
-- Governance Note:   A heavily skewed distribution (a few categories holding most
--                    products) may reflect sourcing focus or data collection bias.
--                    This query also surfaces how consistently the category field
--                    is populated — NULL or blank values would appear as a separate
--                    group and should be flagged as a data quality issue.
-- ============================================================

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

-- ============================================================
-- Query 4: Highest Average Discounts by Category
-- Business Question: Which product categories offer the highest average discount percentages?
-- Purpose:           Identifies categories where sellers apply the deepest discounts
--                    on average. Relevant for pricing strategy analysis and
--                    understanding competitive discount behavior by category.
-- Columns Used:      category, discount_percentage
-- Expected Result:   One row per category with columns: category, avg_discount_percent.
--                    Sorted descending — highest average discount appears first.
-- Governance Note:   Discount percentages should logically fall between 0 and 100.
--                    Categories with averages above 80–90% may contain outliers or
--                    data entry errors worth investigating. This query does not
--                    filter out NULL discount values — nulls are excluded by AVG
--                    automatically, but their presence should be noted.
-- ============================================================

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

-- ============================================================
-- Query 5: Average Price and Rating per Category
-- Business Question: What is the average discounted price and average customer rating
--                    for each product category?
-- Purpose:           Combines pricing and satisfaction data to reveal whether
--                    higher-priced categories also tend to receive better ratings,
--                    or whether budget categories outperform on customer experience.
-- Columns Used:      category, discounted_price, rating
-- Expected Result:   One row per category with columns: category, avg_discounted_price,
--                    avg_rating. Sorted descending by average price.
-- Governance Note:   All prices are in Indian Rupees (₹) — Amazon India marketplace
--                    only. Do not compare these price values to USD or other currency
--                    benchmarks without conversion. The relationship between price
--                    and rating should be interpreted as descriptive, not causal.
-- ============================================================

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

-- ============================================================
-- Query 6: Category Share as Percentage of Total Products
-- Business Question: What percentage of total products does each category represent?
-- Purpose:           Calculates each category's proportional share of the full
--                    product catalog to reveal catalog concentration and identify
--                    dominant versus niche categories.
-- Columns Used:      category
-- Expected Result:   One row per category with columns: category, category_count,
--                    category_percentage. Sorted descending by percentage.
--                    All percentages should sum to approximately 100%.
-- Governance Note:   This query uses a correlated subquery to calculate the total
--                    product count. If the dataset contains duplicate product_id
--                    values, the denominator will be inflated and percentages will
--                    be understated. Verifying product_id uniqueness before running
--                    this query is a recommended data quality step.
-- ============================================================

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

-- ============================================================
-- Query 7: High-Value Deals
-- Business Question: Which products offer both a high discount (greater than 50%)
--                    and a strong customer rating (4.0 or above)?
-- Purpose:           Identifies products that combine significant savings with high
--                    customer satisfaction — the strongest candidates for "Top Deal"
--                    or promotional highlights.
-- Columns Used:      product_name, category, discounted_price, discount_percentage, rating
-- Expected Result:   A filtered list of products meeting both criteria, with columns:
--                    product_name, category, discounted_price, discount_percentage, rating.
--                    Sorted by highest discount first, then highest rating.
-- Governance Note:   The thresholds used here (discount > 50%, rating >= 4.0) are
--                    business rules embedded in the query logic. If these thresholds
--                    change, the query must be updated. Documenting the rationale for
--                    threshold values is a data governance best practice — it ensures
--                    future analysts understand why these cutoffs were chosen.
-- ============================================================

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

-- ============================================================
-- Query 8: Categories with Most High-Rated Products
-- Business Question: Which product categories contain the most products rated 4.5 or higher?
-- Purpose:           Highlights categories with the highest concentration of top-rated
--                    products. Useful for identifying consistently high-performing
--                    categories from a customer satisfaction perspective.
-- Columns Used:      category, rating
-- Expected Result:   One row per category with columns: category, high_rated_products.
--                    Sorted descending — categories with the most top-rated products first.
-- Governance Note:   This query explicitly filters out NULL ratings (rating IS NOT NULL).
--                    The presence of NULL ratings in the dataset is a data quality signal —
--                    products without ratings may be new listings or have had their reviews
--                    removed. The count of excluded NULLs is worth tracking separately
--                    to understand how much of the catalog lacks rating data.
-- ============================================================

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

-- ============================================================
-- Query 9: Products by Price Tier
-- Business Question: How many products fall into Budget, Standard, and Premium price
--                    tiers, and what is the average rating in each tier?
-- Purpose:           Segments the product catalog by price range using a CASE statement.
--                    Reveals whether pricing tier correlates with customer satisfaction
--                    and shows how the catalog is distributed across price points.
-- Columns Used:      discounted_price, rating
-- Expected Result:   Up to 4 rows (Budget, Standard, Premium, Unknown) with columns:
--                    price_tier, product_count, avg_rating_per_tier.
--                    Sorted descending by product count.
-- Governance Note:   The price tier boundaries (₹1,000 and ₹3,000) are business rules
--                    defined in the CASE statement. These thresholds are specific to the
--                    Amazon India marketplace and Indian Rupee pricing. They should not
--                    be applied to other markets without adjustment. An "Unknown" tier
--                    would appear if discounted_price is NULL despite the WHERE filter —
--                    its presence would indicate a data quality issue to investigate.
-- ============================================================

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

-- ============================================================
-- Query 10: Average Discount for Above-Average-Priced Products (CTE)
-- Business Question: What is the average discount percentage for products priced
--                    above the overall average discounted price?
-- Purpose:           Uses a CTE to first calculate the catalog average price, then
--                    filters to above-average-priced products. Explores whether
--                    premium-priced products tend to receive larger or smaller
--                    discounts compared to the full catalog.
-- Columns Used:      discounted_price, discount_percentage
-- Expected Result:   A single row with one column: avg_discount_for_expensive_products.
--                    This is a scalar result — one number representing the average
--                    discount for the filtered subset.
-- Governance Note:   This query demonstrates a CTE (Common Table Expression), which
--                    improves readability by separating the average price calculation
--                    from the main filter logic. CTEs are a maintainability best
--                    practice — they make complex queries easier to audit, document,
--                    and hand off to other analysts. Both discounted_price and
--                    discount_percentage NULL values are explicitly excluded to
--                    prevent silent data gaps from skewing the result.
-- ============================================================

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
