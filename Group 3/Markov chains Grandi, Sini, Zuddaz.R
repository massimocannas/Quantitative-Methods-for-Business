# ==========================================================
# QM PROJECT — Markov Chains
# Transition matrices and steady-state analysis
# ==========================================================

# States:
# N = No stay
# S = Stay
#
# Transition probabilities are NOT known a priori:
# they are computed from observed transition counts
# ----------------------------------------------------------


# ==========================================================
# (1) RAW DATA — OBSERVED COUNTS
# ==========================================================

# --- Dirette ---
counts_dirette <- matrix(c(
  52, 48,   # N -> N, N -> S
  59, 41    # S -> N, S -> S
), nrow = 2, byrow = TRUE)

rownames(counts_dirette) <- c("N", "S")
colnames(counts_dirette) <- c("N", "S")

counts_dirette


# --- Napoleon ---
counts_napoleon <- matrix(c(
  47, 53,
  43, 57
), nrow = 2, byrow = TRUE)

rownames(counts_napoleon) <- c("N", "S")
colnames(counts_napoleon) <- c("N", "S")

counts_napoleon


# --- Sardegna Travel ---
counts_sardegna <- matrix(c(
  44, 56,
  51, 49
), nrow = 2, byrow = TRUE)

rownames(counts_sardegna) <- c("N", "S")
colnames(counts_sardegna) <- c("N", "S")

counts_sardegna


# ==========================================================
# (2) FUNCTION TO BUILD THE TRANSITION MATRIX
# ==========================================================

transition_matrix <- function(counts) {
  counts / rowSums(counts)
}


# ==========================================================
# (3) TRANSITION MATRICES
# ==========================================================

P_dirette  <- transition_matrix(counts_dirette)
P_napoleon <- transition_matrix(counts_napoleon)
P_sardegna <- transition_matrix(counts_sardegna)

P_dirette
P_napoleon
P_sardegna


# Check: each row must sum to 1
rowSums(P_dirette)
rowSums(P_napoleon)
rowSums(P_sardegna)


# ==========================================================
# (4) FUNCTION FOR THE STEADY-STATE DISTRIBUTION
#     Solves: π = πP , with π1 + π2 = 1
# ==========================================================

steady_state <- function(P) {
  
  A <- matrix(c(1 - P[1,1], -P[2,1],
                1,           1),
              nrow = 2, byrow = TRUE)
  
  b <- c(0, 1)
  
  solve(A, b)
}


# ==========================================================
# (5) STEADY-STATE DISTRIBUTIONS
# ==========================================================

pi_dirette  <- steady_state(P_dirette)
pi_napoleon <- steady_state(P_napoleon)
pi_sardegna <- steady_state(P_sardegna)

pi_dirette
pi_napoleon
pi_sardegna


# Verification: πP = π
pi_dirette  %*% P_dirette
pi_napoleon %*% P_napoleon
pi_sardegna %*% P_sardegna


# ==========================================================
# (6) FINAL COMPARISON
# ==========================================================

steady_states <- rbind(
  Dirette = pi_dirette,
  Napoleon = pi_napoleon,
  Sardegna_Travel = pi_sardegna
)

colnames(steady_states) <- c("N", "S")
steady_states


# ==========================================================
# (7) READABLE OUTPUT
# ==========================================================

cat("\nSteady-state probabilities in the long run:\n\n")

cat("Dirette -> N:", round(pi_dirette[1], 3),
    " S:", round(pi_dirette[2], 3), "\n")

cat("Napoleon -> N:", round(pi_napoleon[1], 3),
    " S:", round(pi_napoleon[2], 3), "\n")

cat("Sardegna Travel -> N:", round(pi_sardegna[1], 3),
    " S:", round(pi_sardegna[2], 3), "\n")
