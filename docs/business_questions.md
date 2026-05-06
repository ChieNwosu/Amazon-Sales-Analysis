# Business Questions

This document lists the ten business questions addressed in the Amazon Sales Analysis project. Each entry explains what the question is asking, what it measures, which data points it draws from, and why that measurement matters in a data analytics or data governance context.

---

## 1. What is the overall performance summary of Amazon products in this dataset?

**What it measures:**
A high-level snapshot of the entire dataset — how many products exist, how many distinct categories are represented, what the average customer rating looks like, the range of prices, and the typical discount applied.

**Key data points used:**
Total product count, number of unique categories, average rating, lowest and highest discounted prices, average discounted price, and average discount percentage.

**Why it matters:**
Before drawing any conclusions from a dataset, a business needs to understand what it is working with. This summary acts as a health check — confirming the data is complete, identifying the scale of the catalog, and setting a baseline for every comparison that follows. In data governance terms, this is the first step in assessing data coverage and fitness for use.

---

## 2. Which product categories have the highest and lowest average customer ratings?

**What it measures:**
The average customer satisfaction score for each product category, ranked from best to worst.

**Key data points used:**
Product category and customer rating.

**Why it matters:**
Customer ratings are a direct signal of product quality and buyer satisfaction. Knowing which categories consistently earn high marks — and which fall short — helps a business prioritize quality improvement efforts, make smarter inventory decisions, and identify where customer experience may be at risk. For a data governance team, this also highlights categories where rating data may need closer scrutiny for completeness or accuracy.

---

## 3. How are products distributed across categories in this dataset?

**What it measures:**
The number of products listed in each category, revealing which categories dominate the catalog and which are underrepresented.

**Key data points used:**
Product category.

**Why it matters:**
Understanding catalog composition is fundamental to any retail or e-commerce analysis. A heavily skewed distribution — where a few categories hold most of the products — can signal gaps in coverage, sourcing imbalances, or areas of strategic focus. From a metadata management perspective, this question also surfaces how consistently categories are assigned across the dataset.

---

## 4. Which product categories offer the highest average discount percentages?

**What it measures:**
The average discount applied to products within each category, identifying where sellers are cutting prices the most.

**Key data points used:**
Product category and discount percentage.

**Why it matters:**
Discount behavior varies significantly by category and can reflect competitive pressure, inventory clearance strategies, or seasonal promotions. A business can use this insight to benchmark pricing practices, evaluate margin risk, and understand where value is being passed to customers. For data quality purposes, unusually high or low discount averages can also flag data entry errors worth investigating.

---

## 5. What is the average discounted price and average customer rating for each product category?

**What it measures:**
A side-by-side view of the typical selling price and typical customer satisfaction score for each category, allowing a direct comparison between price point and perceived quality.

**Key data points used:**
Product category, discounted price, and customer rating.

**Why it matters:**
Price and quality do not always move together. This question helps a business determine whether customers in higher-priced categories are actually more satisfied — or whether budget categories are quietly outperforming on experience. This kind of cross-metric analysis is central to value proposition assessments and helps inform both pricing and product curation decisions.

---

## 6. What percentage of total products does each category represent?

**What it measures:**
Each category's share of the full product catalog, expressed as a percentage.

**Key data points used:**
Product category and total product count.

**Why it matters:**
Knowing that a category holds 200 products is less meaningful without knowing whether that represents 5% or 40% of the catalog. Proportional representation reveals catalog concentration — whether the business is heavily dependent on a few categories or has a well-diversified offering. This is also a useful data governance metric for assessing whether category classifications are being applied consistently and proportionally across the dataset.

---

## 7. Which products offer both a high discount (greater than 50%) and a strong customer rating (4.0 or above)?

**What it measures:**
A filtered list of products that combine significant price reductions with high customer satisfaction — the strongest candidates for promotional highlights or "best deal" features.

**Key data points used:**
Product name, category, discounted price, discount percentage, and customer rating.

**Why it matters:**
Not all discounted products are worth promoting. A deep discount on a poorly rated product may attract returns and damage brand trust. This question identifies the intersection of value and quality — products that are both affordable and well-regarded. For a business, this list is directly actionable for marketing campaigns, featured product placements, or customer recommendation engines.

---

## 8. Which product categories contain the most products rated 4.5 or higher?

**What it measures:**
The count of top-rated products (rated 4.5 or above) within each category, identifying which categories have the highest concentration of standout performers.

**Key data points used:**
Product category and customer rating.

**Why it matters:**
A category with many highly rated products signals consistent quality and strong customer trust. This insight helps a business identify its most reliable product lines and can guide decisions around catalog expansion, supplier relationships, and customer-facing recommendations. From a data quality standpoint, it also helps validate whether high ratings are distributed realistically or concentrated in ways that might suggest data anomalies.

---

## 9. How many products fall into Budget, Standard, and Premium price tiers, and what is the average rating in each tier?

**What it measures:**
The number of products in each price tier — Budget (under ₹1,000), Standard (₹1,000–₹3,000), and Premium (above ₹3,000) — along with the average customer rating for each tier.

**Key data points used:**
Discounted price (used to assign each product to a tier) and customer rating.

**Why it matters:**
Price segmentation is a foundational concept in retail analytics. This question reveals how the catalog is distributed across price points and whether customers in higher price tiers are more or less satisfied than those buying budget products. The findings can inform pricing strategy, product positioning, and customer targeting. In a data governance context, this type of rule-based classification also demonstrates how business logic can be applied consistently to raw data to create meaningful categories.

---

## 10. What is the average discount percentage for products priced above the overall average discounted price?

**What it measures:**
The typical discount applied specifically to above-average-priced products — exploring whether premium-priced items tend to receive larger or smaller discounts compared to the full catalog.

**Key data points used:**
Discounted price and discount percentage.

**Why it matters:**
This question tests a common business assumption: that higher-priced products may be discounted more aggressively to drive sales, or conversely, that they hold their price better. The answer has implications for pricing strategy, margin management, and promotional planning. Technically, this query also demonstrates the use of a Common Table Expression (CTE) — a method for breaking a complex question into clear, readable steps — which reflects good analytical practice and maintainable query design.
