## Group Members
Jacopo Zoccheddu  
Daniele Tonarelli  
Andrea Dessalvi



## Project Overview
The objective of this project is to support a student in selecting a subset of exams and seminars in order to maximize academic performance, subject to constraints on available study time and required academic credits (CFU).
The project follows a two-step methodological approach:

1. Formulation of a deterministic optimization model, assuming certainty in exam outcomes.
2. Extension of the model to a stochastic setting, introducing uncertainty in the probability of passing exams.

_The R scripts provided focus on data generation and descriptive analysis, while the optimization model is presented at a conceptual level._

<br>
  
## Deterministic Optimization Model (Baseline)
As a first step, we consider a deterministic version of the problem, assuming that all selected exams are passed with certainty.

Let: [x_i =\begin{cases}1 & \text{if activity } i \text{ is selected} \0 & \text{otherwise}\end{cases}]

Where each activity corresponds to either an exam or a seminar.

<br>
  
## Assumption 
In the baseline model, the probability of passing is assumed to be equal to 1 for all activities:

[p_i = 1 \quad \forall i]

<br>
  
## Objective Function
The objective is to maximize the total academic performance:

[\max \sum_i \text{grade}_i \cdot x_i]

<br>
  
## Constraints

1. _Credit constraint_:[\sum_i \text{CFU}i \cdot x_i \geq \text{CFU}{\min}]

2. _Time constraint_:[\sum_i \text{time}i \cdot x_i \leq \text{Time}{\max}]

3. _Binary constraints_:[x_i \in {0,1}]

_This formulation represents the standard linear programming model requested as a starting point._

<br>

## Stochastic Extension of the Model 
After defining the deterministic model, uncertainty is introduced by allowing the probability of passing exams to be lower than one. Each exam is associated with a probability of passing (p_i \in (0,1]), while seminars are assumed to be always passed.


The expected grade for each activity is therefore defined as:

[\mathbb{E}[\text{grade}_i] = p_i \cdot \text{grade}_i]

The objective function becomes:
  
[\max \sum_i p_i \cdot \text{grade}_i \cdot x_i]

This expected-value formulation captures the trade-off between high grades and the risk of failing an exam.

<br>
  
## Dataset Description (data.R)
The dataset is generated via simulation and contains one observation per activity (exam or seminar).


**Main Variables**

1. activity: activity identifier
2. type: Exam or Seminar
3. cfu: number of credits
4. semester: semester in which the activity is offered
5. grade: grade conditional on passing (exams only)
6. p_pass: probability of passing
7. lecture_hours: scheduled lecture hours
8. study_hours: individual study hours
9. total_time: total time required
10. expected_grade: expected academic outcome
11. efficiency: expected grade per hour invested
12. Note on CFU Values


The simulated dataset includes heterogeneous CFU values (6, 9, 12 for exams and 2–3 for seminars).
This choice reflects realistic variability across university courses and directly affects the formulation of credit and time constraints in the optimization problem.

<br>
  
## Analysis Script (script.R)
  
The analysis script performs:  
1. Descriptive statistics for exams and seminars
2. Visualization of uncertainty in passing probabilities
3. Analysis of expected academic performance
4. Efficiency comparisons across exams
5. Comparison of efficiency distributions by semester


The script produces the following plots:  
1. Histogram of probabilities of passing exams
2. Scatter plot of expected grade vs probability of passing
3. Bar chart of exam efficiency
4. Boxplot of efficiency by semester

<br>

## Conclusion
The project provides a clear methodological progression from a deterministic optimization model to a stochastic formulation that incorporates uncertainty.
The R implementation focuses on data simulation and exploratory analysis, while the optimization framework is defined explicitly in the README as required.

_This structure ensures conceptual clarity, methodological correctness, and consistency between theory and empirical analysis._

<br>

## Comments
Comment: Interesting. You need to figure out how to include the probability of passing. As a first step, I suggest you to assume that the probability of passing is 1 and write the problem in standard form. Then you will generalize it. You can write pretty math here in the read me: just put the equation between the dollar sign and use simple formatting, as in this example: $x_1 + 2x_2  \le 3$ 

Matteo Comment: The project is interesting, but the core methodological step is still missing. You were asked to first assume the probability of passing equal to 1 and formulate the problem in standard linear programming form (decision variables, objective function, and constraints). Instead, you directly introduced uncertainty and focused on descriptive and efficiency analyses, without explicitly defining the optimization model. In addition, there is a structural inconsistency in the CFU values. In the project description, exams are described as worth 6 ECTS credits and seminars 3 ECTS credits, but in the dataset some exams have 9 or 12 credits and some seminars have 2 credits. I suggest you to first formalize the optimization problem:
1) define the binary decision variables for exam and seminar selection,
2) specify the objective function in deterministic form,
3) include credit and time constraints for the two students,

Only afterwards generalize the model by reintroducing the probability of passing (e.g., through expected grades or risk constraints).
