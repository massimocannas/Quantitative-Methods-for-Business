COMPONENTS: Alessia A. Sini, Alice Zuddas, Sara M. Grandi
Project Overview

This project analyzes customer booking behavior for a set of holiday houses using stochastic models. Customers interacting with the agency can either complete a booking (*Stay*) or not (*No stay*). The agency can promote its properties through three alternative booking channels: **Dirette**, **Napoleon**, and **Sardegna Travel**.

The project is developed in two main steps. First, a **Markov chain model** is used to provide a descriptive baseline analysis of the long-run behavior of customers under each booking channel. Transition probabilities are estimated from observed data, and steady-state distributions are computed to understand what happens in the long run when no active decision is taken.

In the second step, the model is extended to a **Markov Decision Process (MDP)**. The three booking channels are interpreted as alternative actions available to the agency, each characterized by different customer dynamics and monetary costs. By combining customer retention and operational costs, the MDP framework allows the identification of the booking strategy that maximizes the long-run expected reward under the stated assumptions.

The project aims to illustrate how stochastic models can support managerial decision-making by explicitly accounting for both customer behavior and economic trade-offs.


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
