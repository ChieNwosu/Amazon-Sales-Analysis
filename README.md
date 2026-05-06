# Amazon Sales Analysis: SQL Business Questions & Metadata Documentation Case Study

This project uses a real-world Amazon India product dataset to demonstrate SQL reasoning, business-question mapping, metadata documentation, and data governance awareness. Ten structured business questions are answered using SQL queries that cover aggregation, filtering, CASE-based segmentation, and Common Table Expressions (CTEs). Each query is fully documented with its business purpose, columns used, expected result type, and governance notes.

The project does not require screenshots, a local database, or any execution environment to review. The SQL logic and all supporting documentation are readable directly in this repository.

---

## Dataset Overview

- **Source:** [Amazon Sales Dataset — Kaggle](https://www.kaggle.com/datasets/karkavelrajaj/amazon-sales-dataset)
- **Size:** ~1,400 Amazon India product listings
- **Currency:** All prices are in Indian Rupees (₹) — Amazon India marketplace only
- **Key columns:** `category`, `discounted_price`, `actual_price`, `discount_percentage`, `rating`, `rating_count`
- **Full column definitions:** [docs/data_dictionary.md](docs/data_dictionary.md)

---

## Tools Used

- SQL (SQLite-compatible syntax) — query logic and analysis
- Git / GitHub — version control and portfolio hosting
- Kaggle — dataset source

---

## Project Structure

```
├── amazon.csv                          # Source dataset (Amazon India product listings, unmodified)
├── Amazon Sales Analysis.sql           # Original SQL file (preserved as reference)
├── sql/
│   └── amazon_sales_analysis.sql       # Documented SQL script with structured query comments
├── docs/
│   ├── business_questions.md           # All 10 questions with rationale and key columns
│   ├── data_dictionary.md              # All 16 dataset columns with definitions and governance notes
│   ├── query_interpretations.md        # Output structure and interpretation guidance per query
│   ├── limitations.md                  # Dataset and analysis constraints
│   └── governance_notes.md             # How this project connects to data governance practice
├── README.md
└── LICENSE
```

---

## Key Business Questions

Each question maps directly to a numbered query in `sql/amazon_sales_analysis.sql`.

1. What is the overall performance summary of Amazon products in this dataset?
2. Which product categories have the highest and lowest average customer ratings?
3. How are products distributed across categories in this dataset?
4. Which product categories offer the highest average discount percentages?
5. What is the average discounted price and average customer rating for each product category?
6. What percentage of total products does each category represent?
7. Which products offer both a high discount (greater than 50%) and a strong customer rating (4.0 or above)?
8. Which product categories contain the most products rated 4.5 or higher?
9. How many products fall into Budget, Standard, and Premium price tiers, and what is the average rating in each tier?
10. What is the average discount percentage for products priced above the overall average discounted price?

Full rationale and key columns for each question: [docs/business_questions.md](docs/business_questions.md)

---

## How Each Query Is Documented

Every query in `sql/amazon_sales_analysis.sql` includes a structured comment block in this format:

```sql
-- ============================================================
-- Query N: [Short Title]
-- Business Question: [plain-English question]
-- Purpose:           [what this query measures and why it matters]
-- Columns Used:      [dataset fields the query draws from]
-- Expected Result:   [shape and meaning of the output]
-- Governance Note:   [data quality considerations for this query]
-- ============================================================
```

This format makes each query self-explanatory to a non-technical reviewer without requiring SQL expertise.

---

## SQL Analysis Workflow

The queries follow a deliberate progression from broad to specific:

1. **Data preview** — confirms the import loaded correctly and previews the data structure
2. **Aggregation** — summary statistics and category-level averages establish baselines
3. **Filtering** — `WHERE` clauses isolate specific subsets (e.g., high-discount, high-rated products)
4. **Segmentation** — a `CASE` statement assigns products to price tiers (Budget / Standard / Premium)
5. **CTE** — a Common Table Expression separates the average price calculation from the main filter, demonstrating readable and auditable query structure

---

## Summary of Insights

The analysis surfaces several patterns across the Amazon India product catalog:

- Product distribution across categories is uneven — a small number of categories account for a disproportionate share of listings.
- Customer ratings vary by category, making it possible to identify which product lines consistently earn high marks and which fall below average satisfaction levels.
- Discount behavior differs significantly across categories, reflecting different competitive or promotional strategies.
- Comparing average price and average rating side by side shows that price tier does not uniformly predict customer satisfaction.
- Filtering for products with discounts above 50% and ratings of 4.0 or higher surfaces a subset that combines strong value with customer approval.
- Price tier segmentation reveals how the catalog is distributed across Budget, Standard, and Premium price points.
- The CTE-based query explores whether above-average-priced products tend to receive larger or smaller discounts than the catalog as a whole.

These findings are descriptive and exploratory. They are drawn from a static ~1,400-record snapshot and should not be generalized beyond this dataset.

---

## Data Governance Relevance

This project is structured to reflect the kind of work expected in a Data Governance Intern role:

- **Metadata documentation** — every query is annotated with business purpose, columns used, expected output, and data quality notes, mirroring the documentation maintained in data catalogs and query registries
- **Business definitions** — `docs/business_questions.md` and `docs/data_dictionary.md` establish a shared vocabulary, ensuring that terms like "high-value deal" and "price tier" are defined explicitly before being encoded in query logic
- **Data quality awareness** — each query's governance note identifies at least one data quality consideration (NULL handling, duplicate risk, outlier risk, category normalization issues)
- **Traceability** — a reviewer can follow a complete chain from business question → query logic → output interpretation for any of the ten queries
- **Stakeholder communication** — `docs/query_interpretations.md` explains each query's output in plain English, without SQL jargon
- **Honest scope** — `docs/limitations.md` documents the boundaries of the analysis transparently

Full details: [docs/governance_notes.md](docs/governance_notes.md)

---

## Limitations

This analysis uses a static Kaggle snapshot — not a live production data source. It is focused on SQL reasoning and documentation practice, not production business intelligence or forecasting. All prices are in Indian Rupees (₹) and reflect the Amazon India marketplace only.

Full details: [docs/limitations.md](docs/limitations.md)

---

## How to Review This Project

No local database setup is required to evaluate this project. Everything can be reviewed directly in the repository:

- Read `sql/amazon_sales_analysis.sql` to see the query logic and structured documentation comments
- Read `docs/business_questions.md` for the business rationale behind each query
- Read `docs/query_interpretations.md` for output structure and interpretation guidance
- Read `docs/data_dictionary.md` for column definitions and governance notes
- Read `docs/limitations.md` for an honest account of dataset constraints
- Read `docs/governance_notes.md` for how this project connects to data governance practice

To execute the queries, load `amazon.csv` into any SQLite-compatible tool (such as DBeaver, DB Browser for SQLite, or an online SQL sandbox) and run `sql/amazon_sales_analysis.sql`.
