# Limitations

This document provides an honest account of the constraints and boundaries of this analysis. It is intended to support transparent data governance and help any reviewer accurately interpret the findings.

---

## 1. Static Dataset — Not Real-Time Amazon Data

The dataset used in this project is a static snapshot sourced from Kaggle. It reflects Amazon product listings, prices, ratings, and reviews as they existed at the time the snapshot was captured — not as they exist today. Prices, discount percentages, ratings, and product availability change continuously on Amazon. No conclusions drawn from this analysis should be treated as current or up-to-date.

## 2. Practice-Focused Scope

This project is designed as a SQL analysis practice exercise and portfolio demonstration. It is not intended for production business intelligence, operational reporting, or commercial forecasting. The queries explore patterns in the dataset for learning purposes and should not be used to inform real business decisions.

## 3. Currency and Marketplace

All price values in this dataset are denominated in Indian Rupees (₹) and reflect listings from the Amazon India marketplace specifically. Price tiers (Budget, Standard, Premium) and any price-based observations are not applicable to other Amazon marketplaces or currencies without adjustment.

## 4. Review and Rating Data Quality

The review and rating data in this dataset may contain duplicates, inconsistencies, or artifacts inherited from the original Kaggle source. Individual products may appear multiple times across different rows due to multiple reviewers, and `rating_count` values may not align consistently across duplicate entries. These data quality considerations were not corrected or normalized for this analysis.

## 5. Category Column Structure

The `category` column contains hierarchical, pipe-delimited values (for example, `Electronics|Headphones|In-Ear`). This structure was not normalized or split into separate columns for this analysis. Queries that filter or group by category operate on the full pipe-delimited string, which means results reflect broad category groupings rather than precise subcategory breakdowns. This is a known structural limitation of the dataset as provided.

## 6. Dataset Size and Statistical Representativeness

The dataset contains approximately 1,400 product records. While this is sufficient for practicing SQL aggregation, filtering, and segmentation techniques, it is not statistically representative of Amazon's full product catalog, which spans hundreds of millions of listings. Patterns and averages observed in this dataset should not be generalized to Amazon's broader inventory or used to draw market-level conclusions.

---

*This document is part of a Data Governance Intern portfolio project. The goal is accurate, transparent documentation — not overstating what the dataset can support.*
