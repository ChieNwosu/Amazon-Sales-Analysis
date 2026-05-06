# Query Interpretations

This document explains how to interpret the results of each query in the Amazon Sales Analysis project. For each query you will find the business question it answers, the structure of the output it produces, and a plain-English explanation of what the results mean in a business context.

No screenshots or local database setup are required to understand this documentation. The SQL logic is in `sql/amazon_sales_analysis.sql` and can be reviewed directly.

---

## 1. Overall Performance Summary

**Business Question:** What is the overall performance summary of Amazon products in this dataset?

**Output Structure:**

| Column | What It Represents |
|---|---|
| `total_products` | The total number of product listings in the dataset |
| `unique_categories` | The number of distinct product categories present |
| `avg_rating` | The average customer rating across all products (0.0–5.0 scale) |
| `min_price` | The lowest discounted price in the catalog (₹) |
| `max_price` | The highest discounted price in the catalog (₹) |
| `avg_price` | The average discounted price across all products (₹) |
| `avg_discount` | The average discount percentage applied across all products |

**How to interpret the result:**
This query returns a single summary row covering the full scope of the dataset. It is the starting point for any analysis — confirming how many products are included, how many distinct categories exist, what the average customer rating is, the price range, and the typical discount applied. If `avg_rating` falls outside the 0–5 range or `total_products` seems unexpectedly low, it may indicate an import or data quality issue worth investigating before proceeding.

---

## 2. Category Average Ratings

**Business Question:** Which product categories have the highest and lowest average customer ratings?

**Output Structure:**

| Column | What It Represents |
|---|---|
| `category` | The full category label (pipe-delimited hierarchy string) |
| `avg_rating` | The average customer rating for products in that category, rounded to 2 decimal places |

**How to interpret the result:**
This query returns one row per category, sorted from highest to lowest average rating. Categories at the top of the list are consistently well-reviewed by customers. Categories near the bottom may have quality issues, unmet customer expectations, or a small number of reviews skewing the average. Because the `category` column stores a full hierarchy string (e.g., `Electronics|Headphones|WiredHeadphones`), each unique string is treated as a separate category — minor naming variations will produce separate rows.

---

## 3. Product Distribution by Category

**Business Question:** How are products distributed across categories in this dataset?

**Output Structure:**

| Column | What It Represents |
|---|---|
| `category` | The full category label |
| `num_products` | The number of products listed in that category |

**How to interpret the result:**
This query returns one row per category, sorted from most to fewest products. It reveals which categories dominate the catalog and which are underrepresented. A heavily skewed distribution — where a few categories hold most of the products — can signal sourcing focus, data collection bias, or gaps in catalog coverage. If any rows appear with a blank or NULL category, that is a data quality signal worth flagging.

---

## 4. Highest Average Discounts by Category

**Business Question:** Which product categories offer the highest average discount percentages?

**Output Structure:**

| Column | What It Represents |
|---|---|
| `category` | The full category label |
| `avg_discount_percent` | The average discount percentage for products in that category, rounded to 2 decimal places |

**How to interpret the result:**
This query returns one row per category, sorted from highest to lowest average discount. Categories at the top are where sellers are cutting prices the most on average. This can reflect competitive pressure, inventory clearance strategies, or promotional behavior. Categories with average discounts above 80–90% may contain outliers or data entry errors worth investigating — discount percentages should logically fall between 0 and 100.

---

## 5. Average Price and Rating per Category

**Business Question:** What is the average discounted price and average customer rating for each product category?

**Output Structure:**

| Column | What It Represents |
|---|---|
| `category` | The full category label |
| `avg_discounted_price` | The average selling price for products in that category (₹) |
| `avg_rating` | The average customer rating for products in that category |

**How to interpret the result:**
This query returns one row per category, sorted from highest to lowest average price. It places pricing and satisfaction side by side, allowing a direct comparison. The results can reveal whether higher-priced categories also earn higher ratings — or whether budget categories quietly outperform on customer experience. All prices are in Indian Rupees (₹) and reflect the Amazon India marketplace only.

---

## 6. Category Share as Percentage of Total Products

**Business Question:** What percentage of total products does each category represent?

**Output Structure:**

| Column | What It Represents |
|---|---|
| `category` | The full category label |
| `category_count` | The number of products in that category |
| `category_percentage` | That category's share of the total product catalog, as a percentage |

**How to interpret the result:**
This query returns one row per category, sorted from highest to lowest percentage. It adds proportional context to the raw counts from Query 3 — knowing a category holds 200 products is more meaningful when you also know that represents 15% of the entire catalog. All percentages should sum to approximately 100%. This view helps identify catalog concentration and potential over-reliance on a few categories.

---

## 7. High-Value Deals

**Business Question:** Which products offer both a high discount (greater than 50%) and a strong customer rating (4.0 or above)?

**Output Structure:**

| Column | What It Represents |
|---|---|
| `product_name` | The full name of the product |
| `category` | The category the product belongs to |
| `discounted_price` | The current selling price after the discount (₹) |
| `discount_percentage` | The percentage reduction from the original price |
| `rating` | The product's average customer rating |

**How to interpret the result:**
This query returns a filtered list of products that meet both criteria: discount greater than 50% and rating of 4.0 or higher. Results are sorted by highest discount first, then highest rating. These are the strongest candidates for promotional highlights — products that are both significantly discounted and well-regarded by customers. The thresholds (50% discount, 4.0 rating) are business rules embedded in the query; if those thresholds change, the query logic must be updated accordingly.

---

## 8. Categories with Most High-Rated Products

**Business Question:** Which product categories contain the most products rated 4.5 or higher?

**Output Structure:**

| Column | What It Represents |
|---|---|
| `category` | The full category label |
| `high_rated_products` | The number of products in that category with a rating of 4.5 or higher |

**How to interpret the result:**
This query returns one row per category, sorted from most to fewest top-rated products. Categories at the top have the highest concentration of standout performers — products that customers consistently rate as excellent. Note that this query explicitly excludes NULL ratings. The number of products excluded due to NULL ratings is worth tracking separately as a data quality metric, since it indicates how much of the catalog lacks rating data.

---

## 9. Products by Price Tier

**Business Question:** How many products fall into Budget, Standard, and Premium price tiers, and what is the average rating in each tier?

**Output Structure:**

| Column | What It Represents |
|---|---|
| `price_tier` | The assigned tier: Budget (under ₹1,000), Standard (₹1,000–₹3,000), or Premium (above ₹3,000) |
| `product_count` | The number of products in that price tier |
| `avg_rating_per_tier` | The average customer rating for products in that tier |

**How to interpret the result:**
This query returns up to four rows — one per tier, plus an "Unknown" row if any products have NULL prices despite the WHERE filter. Results are sorted by product count. The output reveals how the catalog is distributed across price points and whether average ratings differ meaningfully between tiers. The tier boundaries (₹1,000 and ₹3,000) are specific to the Amazon India marketplace and should not be applied to other markets without adjustment.

---

## 10. Average Discount for Above-Average-Priced Products (CTE)

**Business Question:** What is the average discount percentage for products priced above the overall average discounted price?

**Output Structure:**

| Column | What It Represents |
|---|---|
| `avg_discount_for_expensive_products` | The average discount percentage for products priced above the catalog average |

**How to interpret the result:**
This query returns a single number — the average discount applied to products priced above the overall catalog average. It answers whether premium-priced products tend to be discounted more or less than the typical product. The query uses a Common Table Expression (CTE) to separate the average price calculation from the main filter logic, making the query easier to read and audit. Both NULL prices and NULL discounts are explicitly excluded to prevent silent data gaps from skewing the result.
