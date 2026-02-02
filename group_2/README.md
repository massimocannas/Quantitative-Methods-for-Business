# Quantitative Methods for Management – Group Project

## Group Members
1. Maria Francesca Baldini
2. Federico Susini
3. Valentina Ena

## The Business Case
Our project focuses on the daily operations of a family-owned bakery here in Sardinia. This business serves two markets: its own retail shop and several local supermarkets. The production mix consists of two main categories: standard bread and traditional Sardinian sweets, which offer higher margins but require more complex resources.

## Our Objective
The main goal is to answer a key management question: **What is the optimal daily production mix to maximize profit?**

To solve this, our model balances several real-world factors:
- **Constraints:** The physical limits of the oven and labor hours.
- **Economics:** The precise cost of ingredients versus the final selling price.
- **Market Dynamics:** The fluctuation of demand from day to day.

## The Data
Originally, we planned to use simulated data for this analysis. However, having a bit more time allowed us to secure actual operational logs from a real bakery.

Instead of relying on perfect averages or estimated costs, we are now working with the real-world numbers of daily production. This shift transforms our work from a theoretical exercise into a concrete management tool, providing results that are grounded in reality and immediately applicable for the business owner.
The dataset includes:
- product types (bread and festive sweets)
- production costs
- selling prices
- demand


## Methodology
We model the problem as a **linear programming optimization** problem and solve it using R (`lpSolve` package).

## Tools Used
- R
- lpSolve
- GitHub

## References
- Course slides: "Quantitative Methods for Management"
- Book: "Data, Models, and Decisions: The Fundamentals of Management Science"
