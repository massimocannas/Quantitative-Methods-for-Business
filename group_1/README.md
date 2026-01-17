# Quantitative Methods Project


## Group Members
Jacopo Zoccheddu  
Daniele Tonarelli  
Andrea Dessalvi

<br>


Project overview

This project addresses a linear programming decision problem in an academic context.
The goal is to model how a student selects a subset of academic activities (exams and seminars) in order to graduate, subject to constraints on credits (CFU) and time availability, while maximizing academic performance.

The exercise is implemented entirely in R and is structured so that the instructor can fully inspect and reproduce the results.

Structure of the repository

The repository contains three essential files:

data.R
Generates a realistic dataset with uncertainty, based on simulated student outcomes.

script.R
Performs descriptive analysis, visualization, and solves the optimization problem using linear programming.

README.md
Explains the modeling choices, the data generation process, and the optimization logic.

Description of the academic environment
Available activities

There are 14 academic activities in total:

Exams (10)

Each exam:

provides CFU,

has an associated grade (between 18 and 30),

has a probability of passing,

requires lecture hours and personal study time.

Semester distribution

First semester (S1):

Exam 1: 6 CFU

Exam 2: 6 CFU

Exam 3: 6 CFU

Exam 4: 9 CFU

Second semester (S2):

Exam 5: 6 CFU

Exam 6: 6 CFU

Exam 7: 9 CFU

Exam 8: 9 CFU

Exam 9: 9 CFU

Exam 10: 12 CFU (high workload exam)

Seminars (4)

Seminars:

do not provide grades,

are always passed,

provide CFU and require study time.

Semester distribution

S1: Seminar 1 (2 CFU), Seminar 2 (3 CFU)

S2: Seminar 3 (2 CFU), Seminar 4 (3 CFU)

Dataset generation (data.R)
Uncertainty and realism

The dataset is not deterministic.
Instead, uncertainty is introduced by simulating outcomes for 100 students per exam.

For each exam:

A latent student ability is simulated.

Students may fail (score < 18) or pass.

From these simulations:

the empirical probability of passing is computed,

a grade parameter is assigned at the exam level.

The grade is an exam characteristic, not a student outcome.

Seminars:

have probability of passing equal to 1,

have no grade (set to NA).

Expected grade

For exams, performance under uncertainty is summarized using:

expected_grade = probability_of_passing × grade


This allows comparison between:

a deterministic perspective (grade only),

a stochastic perspective (expected grade).

Exploratory analysis (script.R)

Before optimization, the script includes:

summary statistics for exams and seminars,

distribution of passing probabilities,

relationship between probability of passing and expected grade,

efficiency analysis (expected grade per hour),

semester-level comparisons.

All plots are generated using ggplot2.

Optimization problem
Decision variables

For each activity 
𝑖
i:

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

Students considered
Student 1 – Early graduation

Needs exactly 9 CFU

Can only choose first semester (S1) activities

Has a tighter time budget

Student 2 – Later graduation

Needs exactly 12 CFU

Can choose activities from both semesters

Has a larger available time budget

Lexicographic optimization approach

To strictly follow the logic of the exercise, a two-stage (lexicographic) linear programming approach is used.

Stage 1 – Feasibility first

Minimize the total number of CFU selected subject to reaching the required CFU.

This guarantees:

no extra credits,

solutions with exactly 9 or 12 CFU.

Stage 2 – Performance maximization

Given the minimal CFU solution from Stage 1:

Deterministic model
Maximizes the sum of grades.

Stochastic model
Maximizes the sum of expected grades.

Time constraints are imposed only as a secondary feasibility condition, reflecting the graduation deadline.

Role of seminars

Seminars play a crucial role:

they provide certain CFU (probability = 1),

they allow students to reach the required CFU without risk,

they are often selected together with exams in optimal solutions.

This reflects the real-world intuition that seminars are useful tools to complete remaining credits safely.

Deterministic vs stochastic interpretation

In the deterministic version, all selected exams are assumed to be passed.

In the stochastic version, the student maximizes expected performance, explicitly accounting for failure risk.

The comparison highlights how uncertainty affects academic planning decisions.

Reproducibility

The random seed is fixed (set.seed(123)).

All results are fully reproducible.

The professor can inspect:

the dataset generation,

the optimization model,

the obtained solutions.

Conclusion

This project provides a complete and coherent implementation of a linear programming problem under uncertainty, fully aligned with the exercise description.
It combines realistic data generation, clear economic intuition, and rigorous optimization modeling.
## Comments
Comment: Interesting. You need to figure out how to include the probability of passing. As a first step, I suggest you to assume that the probability of passing is 1 and write the problem in standard form. Then you will generalize it. You can write pretty math here in the read me: just put the equation between the dollar sign and use simple formatting, as in this example: $x_1 + 2x_2  \le 3$ 

Matteo Comment: The project is interesting, but the core methodological step is still missing. You were asked to first assume the probability of passing equal to 1 and formulate the problem in standard linear programming form (decision variables, objective function, and constraints). Instead, you directly introduced uncertainty and focused on descriptive and efficiency analyses, without explicitly defining the optimization model. In addition, there is a structural inconsistency in the CFU values. In the project description, exams are described as worth 6 ECTS credits and seminars 3 ECTS credits, but in the dataset some exams have 9 or 12 credits and some seminars have 2 credits. I suggest you to first formalize the optimization problem:
1) define the binary decision variables for exam and seminar selection,
2) specify the objective function in deterministic form,
3) include credit and time constraints for the two students,

Only afterwards generalize the model by reintroducing the probability of passing (e.g., through expected grades or risk constraints).
