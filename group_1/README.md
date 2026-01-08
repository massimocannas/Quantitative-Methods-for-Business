Jacopo Zoccheddu;
Daniele Tonarelli;
Andrea Dessalvi.


Brief presentation of Group Essay: The project applies linear programming techniques to formalize and solve an academic planning optimization problem. The model represents the decision process of two university students who must complete their degree requirements under distinct credit and time constraints.The first student is required to obtain 9 ECTS credits and graduate in the February session, while the second student must obtain 12 ECTS credits and graduate in the July session. The decision variables represent the selection of available exams to be taken by each student.Each exam is associated with three quantitative parameters: probability of passing, required preparation time, and expected grade. All exams are worth 6 credits, while seminars, worth 3 credits, are included as auxiliary options; seminars are excluded from the objective function since they are ungraded and do not depend on the decision variables. The optimization problem is subject to credit completion constraints and graduation deadline constraints, and aims to determine the optimal combination of exams (and seminars, if needed) that maximizes academic performance while minimizing preparation effort and risk of failure.

Comment: Interesting. You need to figure out how to include the probability of passing. As a first step, I suggest you to assume that the probability of passing is 1 and write the problem in standard form. Then you will generalize it. You can write pretty math here in the read me: just put the equation between the dollar sign and use simple formatting, as in this example: $x_1 + 2x_2  \le 3$ 


Matteo Comment: The project is interesting, but the core methodological step is still missing. You were asked to first assume the probability of passing equal to 1 and formulate the problem in standard linear programming form (decision variables, objective function, and constraints). Instead, you directly introduced uncertainty and focused on descriptive and efficiency analyses, without explicitly defining the optimization model. In addition, there is a structural inconsistency in the CFU values. In the project description, exams are described as worth 6 ECTS credits and seminars 3 ECTS credits, but in the dataset some exams have 9 or 12 credits and some seminars have 2 credits. I suggest you to first formalize the optimization problem:
1) define the binary decision variables for exam and seminar selection,
2) specify the objective function in deterministic form,
3) include credit and time constraints for the two students,
Only afterwards generalize the model by reintroducing the probability of passing (e.g., through expected grades or risk constraints).
