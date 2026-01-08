COMPONENTS: Alessia A. Sini, Alice Zuddas, Sara M. Grandi

TOPIC: Markov Chain and MDP related to Summer Holiday rental agency. The aim is to decide which policy apply (e-mail, call or depliant) in order to increase customer retention and maximize long-term expected revenue.

* feedback:

  - analyze the three chains
  - clarify why the chains should be treated separately (do they refer to three separate locations? Otherwise you may consider merging all the data and model the evolution of the resulting chain)
  - As for possible MDP modeling, do you have data to estimate how an action (say, "call" in case of no booking) modifies the transition probabilities? If not, you may think of a reasonable guess (say, no action correpsond to the underlying chain, if action "call" probability of booking increases by 0.05, and so on. Note also that you need to assocuate a cost to each action.
  - please do not share (or cover) personal details on the files


Matteo's comment: The project developed so far is correct, however, at this stage, the work remains purely descriptive. It is important to clarify in the readme file that the three chains (Dirette, Napoleon, and Sardegna Travel) do not represent three independent processes, but rather three alternative interaction strategies applied to the same system (different booking channels for the same holiday houses). Therefore, the comparison of steady-state distributions should be interpreted as a comparison between channels, not between separate systems. In this sense, the current analysis can be kept as a descriptive baseline, showing what happens in the long run when no active decision is taken (“what happens if we do nothing”). To make the project more complete and better aligned with the objective, you can extend the model by introducing an MDP. In particular, you may proceed as follows:
 - use the existing states (Stay / No stay) as the states of the MDP
 - interpret the three booking channels as alternative actions or policies available to the agency
 - use the already estimated transition matrices as the dynamics associated with each action, clearly motivating this modeling choice
 - associate a hypothetical cost (but realistic) to each action, stating that these costs are assumed and not based on real data
 - define a reward (or cost) function that accounts for both customer retention and action costs, and formulate the objective as the maximization of the long-run expected value
 - analyze and compare the resulting policies, discussing which strategy is optimal under the stated assumptions
