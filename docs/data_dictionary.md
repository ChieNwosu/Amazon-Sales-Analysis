# Data Dictionary — amazon.csv

This document defines all 16 columns in the `amazon.csv` dataset. It is intended for both technical and non-technical readers who want to understand what each field contains, how it is used in the SQL analysis, and any known data quality considerations.

**Dataset:** Amazon India product listings and customer reviews (Kaggle snapshot, ~1,400 rows)
**Currency:** All price columns are in Indian Rupees (₹) — Amazon India marketplace only.

---

## Column Reference

| # | Column Name | Data Type | Description | Example Value | Used in Analysis |
|---|-------------|-----------|-------------|---------------|-----------------|
| 1 | `product_id` | VARCHAR | Unique identifier for each product listing | `B07JW9H4J1` | No |
| 2 | `product_name` | VARCHAR | Full name of the product as listed on Amazon | `Boat Bassheads 100 in Ear Wired Earphones` | Yes — Q7 |
| 3 | `category` | VARCHAR | Product category, stored as a pipe-delimited hierarchy | `Electronics\|Headphones\|WiredHeadphones` | Yes — Q2, Q3, Q4, Q5, Q6, Q8 |
| 4 | `discounted_price` | DECIMAL(10,2) | The sale price of the product after discount, in ₹ | `999.00` | Yes — Q1, Q5, Q7, Q9, Q10 |
| 5 | `actual_price` | DECIMAL(10,2) | The original listed price before any discount, in ₹ | `1499.00` | No |
| 6 | `discount_percentage` | DECIMAL(5,2) | The percentage discount applied to the product | `33.00` | Yes — Q1, Q4, Q7, Q10 |
| 7 | `rating` | DECIMAL(3,1) | Average customer rating on a scale of 0.0 to 5.0 | `4.2` | Yes — Q1, Q2, Q5, Q7, Q8, Q9 |
| 8 | `rating_count` | INT | Total number of customer ratings received for the product | `1250` | No |
| 9 | `about_product` | TEXT | A text description of the product features and specifications | `In-ear design, 10mm driver, 1.2m cable` | No |
| 10 | `user_id` | VARCHAR | Unique identifier for the reviewer who submitted the review | `AG3D6O4STAQKAY2UVGEUV` | No |
| 11 | `user_name` | VARCHAR | Display name of the reviewer | `Ankit M.` | No |
| 12 | `review_id` | VARCHAR | Unique identifier for each individual review | `R3BQNSO5OZ58Q4` | No |
| 13 | `review_title` | VARCHAR | Short headline summarizing the reviewer's opinion | `Great sound quality for the price` | No |
| 14 | `review_content` | TEXT | Full text of the customer review | `I bought this for daily commute use and the sound quality is impressive...` | No |
| 15 | `img_link` | VARCHAR | URL pointing to the product image on Amazon | `https://m.media-amazon.com/images/...` | No |
| 16 | `product_link` | VARCHAR | URL pointing to the product's Amazon listing page | `https://www.amazon.in/dp/B07JW9H4J1` | No |

---

## Governance Notes

The following columns have known data quality considerations that are worth understanding before drawing conclusions from the analysis.

### `product_id` — Uniqueness Assumption
This column is expected to hold one unique value per product. If duplicate `product_id` values exist in the dataset, it would indicate a data integrity issue — for example, the same product appearing more than once with different review data attached. This column was not used in the SQL analysis but would be the first place to check in any data quality audit.

### `category` — Non-Normalized Hierarchy
Category values are stored as a full hierarchy string using pipe (`|`) as a separator — for example, `Electronics|Headphones|WiredHeadphones`. The entire string is treated as a single label in this analysis. This means grouping by category groups on the full path, not on individual levels. If the same product appears under slightly different category strings (e.g., a trailing space or a different capitalization), it will be counted as a separate category. This limits grouping accuracy and is a known limitation of the dataset.

### `discounted_price` and `actual_price` — Currency Context
Both price columns are denominated in Indian Rupees (₹). These figures reflect the Amazon India marketplace and should not be interpreted as USD or any other currency. A price of ₹999 is roughly equivalent to $12 USD (exchange rates vary). Any price-based comparisons or thresholds in the analysis are calibrated to the Indian market.

### `discount_percentage` — Outlier Risk
Discount values should logically fall between 0% and 100%. Values above 90% are unusual and may indicate promotional pricing anomalies or data entry errors. If any such outliers appear in the dataset, they could skew averages in queries that aggregate discount percentages (Q1, Q4, Q7, Q10).

### `rating` — Reliability Depends on Volume
The `rating` column stores an average across all reviewers, but it does not tell you how many reviews that average is based on. A product with a 4.8 rating from 3 reviews is statistically less reliable than one with a 4.5 rating from 10,000 reviews. For a more complete picture, `rating` should always be interpreted alongside `rating_count`. The current analysis uses `rating` alone, which is a known limitation.

### `rating_count` — Not Used, But Relevant
This column was not directly used in any of the 10 SQL queries. However, it is the most important companion to the `rating` column for assessing statistical reliability. Any future analysis that filters or ranks by rating should consider applying a minimum `rating_count` threshold (e.g., at least 50 ratings) to avoid surfacing misleading results from low-volume products.

### `user_id` — Multiple Reviews Per User
A single `user_id` may appear more than once in the dataset if that user reviewed multiple products. This is expected behavior and does not indicate a data problem. However, it means the dataset is not a one-row-per-user structure — it is a one-row-per-review structure. This distinction matters for any user-level analysis, though it is not relevant to the current product-focused queries.

### `user_name` — Personally Identifiable Information (PII)
This column contains the display name of the reviewer, which may be a real name or a partial name (e.g., `Ankit M.`). This qualifies as personally identifiable information (PII). In any production or shared environment, this column should be masked, anonymized, or excluded from exports. It is not used in this analysis.

### `review_content` — Unstructured Free Text
The full review text is free-form, user-generated content. It may include noise, off-topic commentary, non-English text, or formatting inconsistencies. This column is not suitable for structured analysis without preprocessing (e.g., sentiment analysis or keyword extraction). It is not used in this analysis.

### `img_link` and `product_link` — URL Staleness
Both URL columns point to Amazon's servers. Because this dataset is a static Kaggle snapshot, these URLs may become broken over time as Amazon updates its content delivery network (CDN) or product listings. They are not suitable for long-term archival use and are not used in this analysis. Note that `product_link` URLs point to `amazon.in`, confirming the Indian marketplace origin of the data.
