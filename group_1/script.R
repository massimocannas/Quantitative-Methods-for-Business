############################################
# QM PROJECT – ANALYSIS SCRIPT (CLEAN)
############################################

### 1. CLEAN ENVIRONMENT
rm(list = ls())
graphics.off()
set.seed(123)

### 2. LOAD LIBRARIES
library(ggplot2)
library(lpSolve)

############################################
### 3. LOAD DATA
############################################

load("data/data.Rdata")
stopifnot(exists("data"))

############################################
### 4. DATA PREPARATION
############################################

# Identify exams and seminars
data$type <- ifelse(is.na(data$grade), "Seminar", "Exam")

exams     <- subset(data, type == "Exam")
seminars <- subset(data, type == "Seminar")

############################################
### 5. DESCRIPTIVE ANALYSIS
############################################

summary(exams)
summary(seminars)
table(data$semester)
table(data$type)

############################################
### 6. UNCERTAINTY ANALYSIS
############################################

ggplot(exams, aes(x = p_pass)) +
  geom_histogram(
    binwidth = 0.05,
    fill = "steelblue",
    color = "black"
  ) +
  labs(
    title = "Distribution of Probability of Passing Exams",
    x = "Probability of Passing",
    y = "Number of Exams"
  ) +
  theme_minimal()

############################################
### 7. EXPECTED PERFORMANCE
############################################

print(exams[, c("activity", "grade", "p_pass", "expected_grade")])

ggplot(
  exams,
  aes(
    x = p_pass,
    y = expected_grade,
    label = activity
  )
) +
  geom_point(size = 3, color = "darkred") +
  geom_text(nudge_y = 0.7, size = 3) +
  labs(
    title = "Expected Grade vs Probability of Passing",
    x = "Probability of Passing",
    y = "Expected Grade"
  ) +
  theme_minimal()

############################################
### 8. EFFICIENCY ANALYSIS
############################################

exams_efficiency <- exams[order(-exams$efficiency), ]

ggplot(
  exams_efficiency,
  aes(
    x = reorder(activity, efficiency),
    y = efficiency
  )
) +
  geom_bar(stat = "identity", fill = "darkgreen") +
  coord_flip() +
  labs(
    title = "Efficiency of Exams (Expected Grade per Hour)",
    x = "Exam",
    y = "Efficiency"
  ) +
  theme_minimal()

############################################
### 9. SEMESTER COMPARISON
############################################

ggplot(
  exams,
  aes(
    x = semester,
    y = efficiency
  )
) +
  geom_boxplot(fill = "orange") +
  labs(
    title = "Efficiency Distribution by Semester",
    x = "Semester",
    y = "Efficiency"
  ) +
  theme_minimal()

############################################
# FORMAL MODEL DEFINITION
############################################

# We consider a set of academic activities indexed by i = 1, ..., N,
# where each activity can be either an exam or a seminar.
#
# Decision variable:
#   x_i = 1 if activity i is selected
#   x_i = 0 otherwise
#
# Each activity i is characterized by:
#   - CFU_i        : number of credits
#   - grade_i      : grade obtained if the exam is passed (NA for seminars)
#   - p_i          : probability of passing (p_i = 1 for seminars)
#   - time_i       : total time required
#
############################################
# DETERMINISTIC MODEL (BASELINE)
############################################

# Assumption:
#   All selected exams are passed with certainty:
#       p_i = 1  for all i
#
# Objective function:
#   Maximize total academic performance:
#
#       max  Σ grade_i * x_i
#
# Constraints:
#
#   1) Credit constraint:
#       Σ CFU_i * x_i = CFU_target
#
#   2) Time constraint:
#       Σ time_i * x_i ≤ Time_max
#
#   3) Binary decision variables:
#       x_i ∈ {0,1}  for all i
#
# This formulation represents a standard 0–1 linear programming problem
# (knapsack-type problem).

############################################
# STOCHASTIC MODEL (EXPECTED VALUE FORMULATION)
############################################

# In the stochastic version, exam outcomes are uncertain.
# Each exam i is passed with probability p_i ∈ (0,1],
# while seminars are always passed (p_i = 1).
#
# The expected academic performance of activity i is defined as:
#
#       E[grade_i] = p_i * grade_i
#
# Objective function:
#   Maximize expected academic performance:
#
#       max  Σ (p_i * grade_i) * x_i
#
# Constraints remain unchanged:
#
#   1) Σ CFU_i * x_i = CFU_target
#   2) Σ time_i * x_i ≤ Time_max
#   3) x_i ∈ {0,1}
#
# This expected-value formulation captures the trade-off between
# high grades and the risk of failing exams.

############################################
### 10. OPTIMIZATION – LEXICOGRAPHIC LP
############################################

############################
# STUDENT 1 – FIRST SEMESTER
############################

CFU_req_1  <- 9
Time_max_1 <- 450

data_S1 <- subset(data, semester == "S1")

# ----- STAGE 1: MINIMIZE CFU USED -----
stage1_1 <- lp(
  direction = "min",
  objective.in = data_S1$cfu,
  const.mat   = matrix(data_S1$cfu, nrow = 1),
  const.dir   = ">=",
  const.rhs   = CFU_req_1,
  all.bin     = TRUE
)

CFU_star_1 <- sum(data_S1$cfu * stage1_1$solution)

# ----- STAGE 2A: DETERMINISTIC -----
obj_det_1 <- ifelse(is.na(data_S1$grade), 0, data_S1$grade)

stage2_det_1 <- lp(
  direction = "max",
  objective.in = obj_det_1,
  const.mat   = rbind(
    data_S1$cfu,
    data_S1$total_time
  ),
  const.dir   = c("=", "<="),
  const.rhs   = c(CFU_star_1, Time_max_1),
  all.bin     = TRUE
)

cat("\n===== STUDENT 1 – DETERMINISTIC =====\n")
print(subset(data_S1, stage2_det_1$solution == 1))
cat("Total CFU:", sum(data_S1$cfu * stage2_det_1$solution), "\n")

# ----- STAGE 2B: STOCHASTIC -----
obj_stoch_1 <- ifelse(is.na(data_S1$grade), 0, data_S1$expected_grade)

stage2_stoch_1 <- lp(
  direction = "max",
  objective.in = obj_stoch_1,
  const.mat   = rbind(
    data_S1$cfu,
    data_S1$total_time
  ),
  const.dir   = c("=", "<="),
  const.rhs   = c(CFU_star_1, Time_max_1),
  all.bin     = TRUE
)

cat("\n===== STUDENT 1 – STOCHASTIC =====\n")
print(subset(data_S1, stage2_stoch_1$solution == 1))
cat("Total CFU:", sum(data_S1$cfu * stage2_stoch_1$solution), "\n")

############################
# STUDENT 2 – BOTH SEMESTERS
############################

CFU_req_2  <- 12
Time_max_2 <- 700

data_all <- data

# ----- STAGE 1: MINIMIZE CFU USED -----
stage1_2 <- lp(
  direction = "min",
  objective.in = data_all$cfu,
  const.mat   = matrix(data_all$cfu, nrow = 1),
  const.dir   = ">=",
  const.rhs   = CFU_req_2,
  all.bin     = TRUE
)

CFU_star_2 <- sum(data_all$cfu * stage1_2$solution)

# ----- STAGE 2A: DETERMINISTIC -----
obj_det_2 <- ifelse(is.na(data_all$grade), 0, data_all$grade)

stage2_det_2 <- lp(
  direction = "max",
  objective.in = obj_det_2,
  const.mat   = rbind(
    data_all$cfu,
    data_all$total_time
  ),
  const.dir   = c("=", "<="),
  const.rhs   = c(CFU_star_2, Time_max_2),
  all.bin     = TRUE
)

cat("\n===== STUDENT 2 – DETERMINISTIC =====\n")
print(subset(data_all, stage2_det_2$solution == 1))
cat("Total CFU:", sum(data_all$cfu * stage2_det_2$solution), "\n")

# ----- STAGE 2B: STOCHASTIC -----
obj_stoch_2 <- ifelse(is.na(data_all$grade), 0, data_all$expected_grade)

stage2_stoch_2 <- lp(
  direction = "max",
  objective.in = obj_stoch_2,
  const.mat   = rbind(
    data_all$cfu,
    data_all$total_time
  ),
  const.dir   = c("=", "<="),
  const.rhs   = c(CFU_star_2, Time_max_2),
  all.bin     = TRUE
)

cat("\n===== STUDENT 2 – STOCHASTIC =====\n")
print(subset(data_all, stage2_stoch_2$solution == 1))
cat("Total CFU:", sum(data_all$cfu * stage2_stoch_2$solution), "\n")

