# Quantitative Methods for Business – Group Project
## Group members
1. Maria Francesca Baldini
2. Federico Susini
3. Valentina Ena

## Business Case
This project analyzes a family-owned bakery that supplies both its own retail shop and local supermarkets. The bakery produces standard bread on a daily basis and festive sweets during peak periods such as holidays.

## Objective
The objective of the project is to optimize daily production quantities in order to maximize profit.
The decision must take into account:
- limited production capacity
- unit production costs and selling prices
- demand differences between normal and festive periods

## Data
Since real company data were not available, a synthetic dataset was generated using R.
The dataset represents a typical daily decision scenario rather than a full-time series.
Demand levels were simulated for two different situations:
- normal days
- festive days

Prices, costs and production times were fixed based on realistic assumptions for a small family-owned bakery.

**Production times** per unit were fixed based on realistic assumptions regarding the production process of a small bakery. Bread production is more standardized, while festive sweets require additional manual work. 0.05 and 0.12 are order-of-magnitude estimates. The exact values are less important than their relative difference, which reflects the higher production complexity of festive sweets.

## Methodology
The problem is formulated as a linear programming optimization model.
The objective function maximizes total daily profit subject to:
- production capacity constraints
- demand constraints

The optimization problem is solved using R, with the support of the `lpSolve` package.

## Tools
- R
- lpSolve
 Comment: can you add (either in the readme or in the R file) the standard form of the linear programming problem?  
## References
- Course slides
