COMPONENTS: Alessia A. Sini, Alice Zuddas, Sara M. Grandi

TOPIC: Markov Chain and MDP related to Summer Holiday rental agency. The aim is to decide which policy apply (e-mail, call or depliant) in order to increase customer retention and maximize long-term expected revenue.

* feedback:

  - analyze the three chains
  - clarify why the chains should be treated separately (do they refer to three separate locations? Otherwise you may consider merging all the data and model the evolution of the resulting chain)
  - As for possible MDP modeling, do you have data to estimate how an action (say, "call" in case of no booking) modifies the transition probabilities? If not, you may think of a reasonable guess (say, no action correpsond to the underlying chain, if action "call" probability of booking increases by 0.05, and so on. Note also that you need to assocuate a cost to each action.
  - please do not share (or cover) personal details on the files
