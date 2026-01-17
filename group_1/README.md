# Quantitative Methods Project


## Group Members
Jacopo Zoccheddu  
Daniele Tonarelli  
Andrea Dessalvi

<br>​
​
## Project overview

This project studies a constrained decision-making problem faced by a university student who must complete a limited number of remaining academic credits (CFU) in order to graduate.
The student can choose among a set of academic activities consisting of exams and seminars.
Each activity is characterized by a number of credits, a required amount of study time, and, in the case of exams, an uncertain outcome.

The objective of the project is to formulate this decision problem as a linear programming model.
The analysis proceeds in two steps.
First, a deterministic version of the problem is introduced, assuming that all selected exams are passed with certainty.
Second, the model is extended to a stochastic setting, where exam outcomes are uncertain and performance is evaluated in expected terms.

The focus of the project is methodological.
The goal is not to compute a single numerical solution, but rather to show how a realistic academic planning problem can be translated into a formal optimization framework.

## Academic activities

The set of available activities consists of fourteen elements.
Ten of them are exams and four are seminars.
Exams provide either 6, 9, or 12 CFU, require both lecture hours and personal study time, and are associated with a grade that is obtained only if the exam is passed.
Seminars provide a smaller number of credits (2 or 3 CFU), require study time, but do not contribute to grades and are always passed.

Activities are distributed across two semesters.
Some exams and seminars are offered in the first semester, while others are available only in the second semester.
This distinction is relevant because students may face different graduation deadlines.

## Data generation and uncertainty

The dataset used in the project is generated synthetically in order to resemble realistic academic outcomes.
For each exam, grades are simulated for a sample of one hundred students.
The simulated outcomes include both sufficient and insufficient grades, reflecting the possibility of failing an exam.

From these simulated grades, two quantities are computed for each exam.
First, the average grade conditional on passing is calculated.
Second, the empirical probability of passing is estimated as the fraction of students who achieve a sufficient grade.
Seminars are assumed to be always passed and are therefore assigned a probability of passing equal to one.

Using these quantities, an expected grade is defined for each exam as the product of the probability of passing and the average grade.
For seminars, the expected grade is set equal to zero.

## Deterministic optimization model

Let $$i = 1$$ index the available academic activities.
For each activity, a binary decision variable is defined as

$$
[x_i =\begin{cases}1 & \text{if activity } i \text{ is selected}, \\0 & \text{otherwise}\end{cases}]
$$

Each activity $i$ is associated with a number of credits $CFU_i$, a grade $grade_i$ (defined only for exams), and a required amount of time $time_i$.

In the deterministic version of the problem, it is assumed that all selected exams are passed with certainty.
Under this assumption, the optimization problem is formulated as

$$
\[\max \sum_{i=1}^{N} grade_i \, x_i\]
$$

subject to the constraints

$$
\[\sum_{i=1}^{N} CFU_i \, x_i = CFU_{\text{target}},\]
$$

$$
\[\sum_{i=1}^{N} time_i \, x_i \leq Time_{\text{max}},\]
$$

$$
\[x_i \in \{0,1\} \qquad \forall i = 1,\ldots,N.\]
$$

This formulation represents a standard $0$ -- $1$ linear programming problem of the knapsack type.
Seminars do not contribute to the objective function, but they may be selected in order to satisfy the credit constraint.

## Stochastic extension

The deterministic assumption that all exams are passed is unrealistic.
In practice, each exam is passed only with a certain probability.
To account for this, the model is extended to a stochastic setting.

Each exam $i$ is associated with a probability of passing $p_i \in (0,1]$, estimated empirically from the simulated student outcomes.
Seminars are assumed to be passed with probability one.

The expected academic performance of activity $i$ is defined as

$$
\[\mathbb{E}[grade_i] = p_i \cdot grade_i.\]
$$

The stochastic optimization problem is then formulated as

$$
\[\max \sum_{i=1}^{N} p_i \cdot grade_i \, x_i\]
$$

subject to the same constraints as in the deterministic case:

$$
\[\sum_{i=1}^{N} CFU_i \, x_i = CFU_{\text{target}},\]
$$

$$
\[\sum_{i=1}^{N} time_i \, x_i \leq Time_{\text{max}},\]
$$

$$
\[x_i \in \{0,1\} \qquad \forall i = 1,\ldots,N.\]
$$

This expected-value formulation captures the trade-off between high grades and the risk of failing exams.
Activities with high nominal grades but low probabilities of passing may become less attractive when uncertainty is taken into account.

## Students considered

The same set of activities is considered for two different students.
The first student must graduate earlier and can select only activities offered in the first semester.
This student must complete exactly nine CFU and faces a relatively tight time constraint.

The second student has a later graduation deadline and can select activities from both semesters.
This student must complete exactly twelve CFU and has a larger available time budget.

The optimization problem is solved separately for each student under both deterministic and stochastic assumptions.

## Implementation

The project is implemented in R.
The file data.R generates the dataset, including simulated grades, probabilities of passing, expected grades, and efficiency measures.
The file script.R loads the dataset, performs descriptive analysis and visualization, explicitly states the mathematical formulation of the optimization problem, and solves both the deterministic and stochastic models using binary linear programming.

The entire project is fully reproducible by running the data generation script first and then the analysis script.



	​




## Comments
Comment: Interesting. You need to figure out how to include the probability of passing. As a first step, I suggest you to assume that the probability of passing is 1 and write the problem in standard form. Then you will generalize it. You can write pretty math here in the read me: just put the equation between the dollar sign and use simple formatting, as in this example: $x_1 + 2x_2  \le 3$ 

Matteo Comment: The project is interesting, but the core methodological step is still missing. You were asked to first assume the probability of passing equal to 1 and formulate the problem in standard linear programming form (decision variables, objective function, and constraints). Instead, you directly introduced uncertainty and focused on descriptive and efficiency analyses, without explicitly defining the optimization model. In addition, there is a structural inconsistency in the CFU values. In the project description, exams are described as worth 6 ECTS credits and seminars 3 ECTS credits, but in the dataset some exams have 9 or 12 credits and some seminars have 2 credits. I suggest you to first formalize the optimization problem:
1) define the binary decision variables for exam and seminar selection,
2) specify the objective function in deterministic form,
3) include credit and time constraints for the two students,

Only afterwards generalize the model by reintroducing the probability of passing (e.g., through expected grades or risk constraints).
