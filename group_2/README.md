# Quantitative Methods for Management – Group Project 
## Group Members 
 - Maria Francesca Baldini 
 - Federico Susini 
 - Valentina Ena 
## The Business Case 
Our project focuses on the daily operations of a family-owned bakery here in Sardinia. This business serves two markets: its own retail shop and several local supermarkets. The production mix consists of two main categories: 
 - **Standard bread**, characterized by stable demand and lower margins; 
 - **Traditional Sardinian sweets**, which are more profitable but require greater use of time and raw materials; 

This dual production structure creates a classic resource allocation problem, where limited inputs must be optimally distributed across products. The main goal is to answer a key management question: **What is the optimal daily production mix to maximize profit?** 

$$Max Z = \pi_1 x_1 + \pi_2 x_2$$ 

To solve this, our model balances several real-world factors: 
 - **Constraints:** availability of flour, yeast, and working hours;
 - **Economic variables:** selling prices and production costs;
 - **Market Dynamics:** The fluctuation of demand from day to day. Maximum observed market demand for each product. 
## The Data 
Originally, we planned to use simulated data for this analysis. However, given the additional time, we were able to obtain real operational data from an actual bakery. Instead of relying on perfect averages or estimated costs, we are now working with the real-world numbers of daily production. This shift transforms our work from a theoretical exercise into a concrete management tool, providing results that are grounded in reality and immediately applicable for the business owner.
The dataset is structured daily and includes: 
 - Product type (bread or festive sweets)
 - Quantity produced
 - Unit production costs 
 - Selling prices 
 - Flour and yeast consumption per unit 
 - Time required per unit 
 - Daily demand 
 - Available working hours per day 

### Preparation of the data
To be able to work with our dataset, we had to filling missing dates and available working hours and onverting dates and classifying days into two periods: 

 - Normal days 
 - Festive days (Christmas period)

 
 We also had to computing total daily usage of flour and yeast and splitting the dataset by period to capture seasonal differences in production and demand 
 
## Methodology 
We model the problem as a linear programming (LP) profit maximization problem, solved using the lpSolve package in R.  For each period (Normal and Festive), we:

 - Aggregate data by product, computing:
	- Mean prices, costs, resource usage, and time requirements
	- Maximum observed demand (used as an upper bound)
 - Define the objective function as: 

$$\text{Maximize profit} = (price − cost) × \text{quantity produced}$$

 - Impose the following constraints: 
	- Flour availability 
	- Yeast availability 
	- Available working hours 
	- Maximum demand for bread 
	- Maximum demand for sweets 

We used realistic limits from the data: 
 - **Flour and yeast constraints (f, l)** are set at the **75th percentile** of observed daily usage; 
 - **Working time constraints (w)** are computed as the average available working hours, excluding non-working days. 

This approach ensures that the optimization reflects realistic and robust operational conditions, rather than extreme or idealized values. Variables and Parameters:

$$
\begin{cases} 
f_1 x_1 + f_2 x_2 \le F \\
l_1 x_1 + l_2 x_2 \le L \\
w_1 x_1 + w_2 x_2 \le W \\
x_1 \le D_1 \\
x_2 \le D_2 \\
x_1, x_2 \ge 0 
\end{cases}
$$

The coefficient matrix:

$$
\begin{bmatrix}
f_1 & f_2 \\
l_1 & l_2 \\
w_1 & w_2 \\
1 & 0 \\
0 & 1
\end{bmatrix}
$$

The model is solved separately for normal days and festive days. This allows us to capture how optimal production decisions change during periods of higher demand and tighter resource constraints. 
 ## Results 
For each period, the model returns: 
- The optimal daily quantity of bread and sweets to produce; 
- The corresponding maximum achievable daily profit. 
The results provide clear, actionable guidance for the bakery owner on how to adjust production strategies across different seasonal conditions. 
## Tools Used
- **R:** For all data cleaning, reshaping, and the core loop logic.
- **lpSolve:** The library used to run the optimization engine.
- **dplyr, tidyr, readxl:** Library used to clean data and create colums
## References 
- Course slides: "Quantitative Methods for Management" 
- Book: "Data, Models, and Decisions: The Fundamentals of Management Science"
