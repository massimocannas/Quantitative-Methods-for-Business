Project Overview
The objective of this project is to analyse and optimise a transportation decision problem using linear programming. The problem concerns the allocation of shipments from multiple supply locations to multiple demand locations in order to minimise total transportation cost, subject to operational constraints.

The project follows a two-step methodological approach, in line with the course requirements:

Formulation of a deterministic transportation model, assuming that all shipments are delivered with certainty and costs are known.
Extension of the baseline model to consider uncertainty or scenario variation (e.g. demand changes or cost sensitivity), building on the deterministic formulation.
This structure ensures that the core linear programming model is clearly defined before any generalisation or extension is introduced.

Deterministic Transportation Model (Baseline)
Decision Variables
Let:

( i = 1, \dots, I ) index the supply nodes (e.g. production plants, warehouses)
( j = 1, \dots, J ) index the demand nodes (e.g. customers, distribution centres)
We define the decision variables:

[ x_{ij} = \text{quantity transported from supply node } i \text{ to demand node } j ]

These variables represent the shipment quantities to be determined by the optimization model.

Deterministic Assumptions
In the baseline model, the following assumptions are made:

Transportation costs are known and constant.
All shipments are delivered successfully.
Supply and demand levels are fixed and known with certainty.
Under these assumptions, the problem can be formulated as a standard linear programming transportation model.

Objective Function
The objective is to minimise total transportation cost:

[ \min \sum_{i=1}^{I} \sum_{j=1}^{J} c_{ij} , x_{ij} ]

where:

( c_{ij} ) is the unit transportation cost from supply node ( i ) to demand node ( j ).
Constraints
Supply Constraints
Each supply node has a limited capacity:

[ \sum_{j=1}^{J} x_{ij} \le S_i \quad \forall i ]

where ( S_i ) is the available supply at node ( i ).

Demand Constraints
Each demand node must receive a required quantity:

[ \sum_{i=1}^{I} x_{ij} \ge D_j \quad \forall j ]

where ( D_j ) is the demand at node ( j ).

Non-negativity Constraints
[ x_{ij} \ge 0 \quad \forall i,j ]

Standard Linear Programming Form
The deterministic transportation problem can therefore be written as:

[ \begin{aligned} \min \quad & \sum_{i=1}^{I} \sum_{j=1}^{J} c_{ij} x_{ij}
\text{s.t.} \quad & \sum_{j=1}^{J} x_{ij} \le S_i \quad \forall i
& \sum_{i=1}^{I} x_{ij} \ge D_j \quad \forall j
& x_{ij} \ge 0 \quad \forall i,j \end{aligned} ]

This represents the core linear programming formulation of the project.

Model Extension and Analysis
Once the deterministic model is established, it can be extended to analyse alternative scenarios, such as:

changes in demand levels,
variations in transportation costs,
capacity restrictions on specific routes.
These extensions allow the decision-maker to evaluate how sensitive the optimal transportation plan is to changes in key parameters, while preserving the linear programming structure.

Data Description
The model uses real data provided for the project, including:

supply capacities at each origin node,
demand requirements at each destination node,
unit transportation costs for each route.
The total supply equals total demand, resulting in a balanced transportation problem, which is well suited for linear programming analysis.

Methodology
The problem is solved using linear programming, specifically the transportation problem framework, which is a structured special case of LP. The model is implemented using standard optimization tools and solved with the Simplex method.

