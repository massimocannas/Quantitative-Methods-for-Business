Jacopo Zoccheddu;
Daniele Tonarelli;
Andrea Dessalvi.


_**Project Overview**_

The objective of this project is to support a student in selecting a subset of exams and seminars in order to maximize academic performance, subject to constraints on available study time and required academic credits (CFU).
The project follows a two-step methodological approach, as required by the course:

1. Formulation of a deterministic optimization model, assuming certainty in exam outcomes.
2. Extension of the model to a stochastic setting, introducing uncertainty in the probability of passing exams.

_The R scripts provided focus on data generation and descriptive analysis, while the optimization model is presented at a conceptual level._


Comment: Interesting. You need to figure out how to include the probability of passing. As a first step, I suggest you to assume that the probability of passing is 1 and write the problem in standard form. Then you will generalize it. You can write pretty math here in the read me: just put the equation between the dollar sign and use simple formatting, as in this example: $x_1 + 2x_2  \le 3$ 


Matteo Comment: The project is interesting, but the core methodological step is still missing. You were asked to first assume the probability of passing equal to 1 and formulate the problem in standard linear programming form (decision variables, objective function, and constraints). Instead, you directly introduced uncertainty and focused on descriptive and efficiency analyses, without explicitly defining the optimization model. In addition, there is a structural inconsistency in the CFU values. In the project description, exams are described as worth 6 ECTS credits and seminars 3 ECTS credits, but in the dataset some exams have 9 or 12 credits and some seminars have 2 credits. I suggest you to first formalize the optimization problem:
1) define the binary decision variables for exam and seminar selection,
2) specify the objective function in deterministic form,
3) include credit and time constraints for the two students,

Only afterwards generalize the model by reintroducing the probability of passing (e.g., through expected grades or risk constraints).
