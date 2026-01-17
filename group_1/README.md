# Quantitative Methods Project


## Group Members
Jacopo Zoccheddu  
Daniele Tonarelli  
Andrea Dessalvi

<br>

## Project overview

This project addresses a constrained decision-making problem faced by a university student who must complete a limited number of remaining credits (CFU) in order to graduate. The student can choose among a set of available academic activities, consisting of exams and seminars, each characterized by different credit values, time requirements, and (for exams) uncertain outcomes.

The goal of the project is to show how this decision problem can be formulated as a linear programming model, first under deterministic assumptions and then extended to account for uncertainty in exam outcomes. The focus of the project is methodological: the emphasis is on the formulation of the optimization problem rather than on the numerical value of the solution.

The entire workflow is implemented in R and organized into three main components: a data generation script, an analysis and optimization script, and this README file, which documents the modeling choices.

## Description of the academic activities

The dataset includes a total of fourteen activities. Ten of them are exams and four are seminars. Exams provide either 6, 9, or 12 CFU, require both lecture hours and personal study time, and are associated with a grade that is obtained only if the exam is passed. Seminars provide a smaller number of credits (2 or 3 CFU), require study time, but do not contribute to grades and are always passed.

Activities are distributed across two semesters. Some exams and seminars are offered in the first semester, while others are available only in the second semester. This semester structure is relevant because students may face different graduation deadlines.

## Data generation and uncertainty modeling

The dataset is generated synthetically in order to resemble realistic academic outcomes. For each exam, grades are simulated using a sample of one hundred students. These simulated grades include both sufficient and insufficient outcomes, reflecting the possibility of failing an exam.

From these simulated outcomes, two key quantities are computed for each exam. First, the average grade conditional on passing is calculated. Second, the empirical probability of passing is obtained as the share of students who achieve a sufficient grade. Seminars are assigned a probability of passing equal to one by construction.

Using these quantities, an expected grade is defined for each exam as the product of the probability of passing and the average grade. This expected grade is later used in the stochastic formulation of the optimization problem. For seminars, the expected grade is set to zero, since they do not contribute to academic performance in terms of grades.

## Deterministic optimization model (standard form)

The deterministic version of the problem assumes that all selected exams are passed with certainty. Let 
𝑖
=
1
,
…
,
𝑁
i=1,…,N index the available activities. For each activity, a binary decision variable is defined:

𝑥
𝑖
=
{
1
	
if activity 
𝑖
 is selected


0
	
otherwise
x
i
	​

={
1
0
	​

if activity i is selected
otherwise
	​


Each activity is associated with a number of credits 
CFU
𝑖
CFU
i
	​

, a grade 
grade
𝑖
grade
i
	​

 (defined only for exams), and a required amount of time 
time
𝑖
time
i
	​

.

Under deterministic assumptions, the optimization problem is formulated as follows:

max
⁡
∑
𝑖
grade
𝑖
 
𝑥
𝑖
max
i
∑
	​

grade
i
	​

x
i
	​


subject to the constraints

∑
𝑖
CFU
𝑖
 
𝑥
𝑖
=
CFU
target
i
∑
	​

CFU
i
	​

x
i
	​

=CFU
target
	​

∑
𝑖
time
𝑖
 
𝑥
𝑖
≤
Time
max
i
∑
	​

time
i
	​

x
i
	​

≤Time
max
	​

𝑥
𝑖
∈
{
0
,
1
}
∀
𝑖
x
i
	​

∈{0,1}∀i

This formulation represents a standard 0–1 linear programming problem, similar to a knapsack problem. Seminars do not contribute to the objective function but may be selected to satisfy the credit constraint.

Stochastic extension with uncertainty

The deterministic assumption that all exams are passed is unrealistic. In practice, each exam is passed only with a certain probability. To account for this, the model is extended by introducing uncertainty in exam outcomes.

Each exam 
𝑖
i is associated with a probability of passing 
𝑝
𝑖
∈
(
0
,
1
]
p
i
	​

∈(0,1], estimated empirically from the simulated student outcomes. Seminars are assumed to be passed with probability one.

The expected academic performance of an activity is defined as:

𝐸
[
grade
𝑖
]
=
𝑝
𝑖
⋅
grade
𝑖
E[grade
i
	​

]=p
i
	​

⋅grade
i
	​


Using this definition, the objective function becomes:

max
⁡
∑
𝑖
𝑝
𝑖
⋅
grade
𝑖
 
𝑥
𝑖
max
i
∑
	​

p
i
	​

⋅grade
i
	​

x
i
	​


The constraints of the model remain unchanged:

∑
𝑖
CFU
𝑖
 
𝑥
𝑖
=
CFU
target
i
∑
	​

CFU
i
	​

x
i
	​

=CFU
target
	​

∑
𝑖
time
𝑖
 
𝑥
𝑖
≤
Time
max
i
∑
	​

time
i
	​

x
i
	​

≤Time
max
	​

𝑥
𝑖
∈
{
0
,
1
}
∀
𝑖
x
i
	​

∈{0,1}∀i

This expected-value formulation captures the trade-off between high grades and the risk of failing exams. Activities with high grades but low probabilities of passing may become less attractive compared to safer options or seminars.

Students considered

The same set of activities is considered for two different students, who differ only in their constraints. The first student must graduate earlier and can select only first-semester activities. This student faces a tighter time constraint and must complete exactly nine CFU.

The second student has a later graduation deadline and can select activities from both semesters. This student must complete exactly twelve CFU and has a larger time budget.

The optimization problem is solved separately for each student under both deterministic and stochastic assumptions.

Implementation in R

The file data.R generates the dataset, including simulated grades, probabilities of passing, expected grades, and efficiency measures. The file script.R loads the dataset, performs descriptive analysis and visualization, explicitly states the mathematical formulation of the optimization problem, and solves both the deterministic and stochastic models using binary linear programming.

The project is fully reproducible by running the data generation script first and then the analysis script.

## Comments
Comment: Interesting. You need to figure out how to include the probability of passing. As a first step, I suggest you to assume that the probability of passing is 1 and write the problem in standard form. Then you will generalize it. You can write pretty math here in the read me: just put the equation between the dollar sign and use simple formatting, as in this example: $x_1 + 2x_2  \le 3$ 

Matteo Comment: The project is interesting, but the core methodological step is still missing. You were asked to first assume the probability of passing equal to 1 and formulate the problem in standard linear programming form (decision variables, objective function, and constraints). Instead, you directly introduced uncertainty and focused on descriptive and efficiency analyses, without explicitly defining the optimization model. In addition, there is a structural inconsistency in the CFU values. In the project description, exams are described as worth 6 ECTS credits and seminars 3 ECTS credits, but in the dataset some exams have 9 or 12 credits and some seminars have 2 credits. I suggest you to first formalize the optimization problem:
1) define the binary decision variables for exam and seminar selection,
2) specify the objective function in deterministic form,
3) include credit and time constraints for the two students,

Only afterwards generalize the model by reintroducing the probability of passing (e.g., through expected grades or risk constraints).
