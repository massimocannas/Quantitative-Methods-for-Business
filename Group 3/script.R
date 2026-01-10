# ==========================================================
# QM PROJECT — Markov Chains and Markov Decision Process
# ==========================================================

# States:
# 1 = No stay
# 2 = Stay


# ==========================================================
# (1) RAW DATA — OBSERVED COUNTS
# ==========================================================

counts_dirette <- matrix(c(52, 48,
                           59, 41),
                         nrow = 2, byrow = TRUE)

counts_napoleon <- matrix(c(47, 53,
                            43, 57),
                          nrow = 2, byrow = TRUE)

counts_sardegna <- matrix(c(44, 56,
                            51, 49),
                          nrow = 2, byrow = TRUE)


# ==========================================================
# (2) TRANSITION MATRICES
# ==========================================================

transition_matrix <- function(counts) {
  counts / rowSums(counts)
}

P_dirette  <- transition_matrix(counts_dirette)
P_napoleon <- transition_matrix(counts_napoleon)
P_sardegna <- transition_matrix(counts_sardegna)


# ==========================================================
# (3) STEADY-STATE DISTRIBUTIONS (BASELINE)
# ==========================================================

steady_state <- function(P) {
  A <- matrix(c(1 - P[1,1], -P[2,1],
                1, 1),
              nrow = 2, byrow = TRUE)
  b <- c(0, 1)
  solve(A, b)
}

pi_dirette  <- steady_state(P_dirette)
pi_napoleon <- steady_state(P_napoleon)
pi_sardegna <- steady_state(P_sardegna)


# ==========================================================
# (4) MDP PARAMETERS
# ==========================================================

# Average booking revenue (euros)
booking_value <- 100

# State rewards
reward_state <- c(0, booking_value)  # No stay, Stay

# Action costs (euros)
costs <- c(
  Dirette = 0,
  Napoleon = 15,
  Sardegna_Travel = 20
)


# ==========================================================
# (5) LONG-RUN EXPECTED REWARD
# ==========================================================

expected_reward <- function(P, cost) {
  pi <- steady_state(P)
  sum(pi * reward_state) - cost
}

R_dirette  <- as.numeric(expected_reward(P_dirette,  costs["Dirette"]))
R_napoleon <- as.numeric(expected_reward(P_napoleon, costs["Napoleon"]))
R_sardegna <- as.numeric(expected_reward(P_sardegna, costs["Sardegna_Travel"]))

results <- c(
  Dirette = R_dirette,
  Napoleon = R_napoleon,
  Sardegna_Travel = R_sardegna
)

results


# ==========================================================
# (6) OPTIMAL POLICY
# ==========================================================

optimal_action <- names(which.max(results))

cat("\nOptimal booking channel under the stated assumptions:",
    optimal_action, "\n")

