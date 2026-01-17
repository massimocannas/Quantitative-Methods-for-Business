############################################
# DATASET WITH UNCERTAINTY – QM PROJECT
# (Chance-Constrained Logic via Simulation)
############################################

# 1. Clean environment and set seed
rm(list = ls())
set.seed(123)

# 2. General parameters
n_students <- 100
n_exams <- 10
n_seminars <- 4

# 3. Activities
activity <- c(
  paste0("Exam_", 1:n_exams),
  paste0("Seminar_", 1:n_seminars)
)

# 4. CFU structure
cfu <- c(
  6, 6, 6, 9,        # S1 exams
  6, 6, 9, 9, 9, 12, # S2 exams
  2, 3, 2, 3         # Seminars
)

# 5. Semester assignment
semester <- c(
  "S1","S1","S1","S1",
  "S2","S2","S2","S2","S2","S2",
  "S1","S1","S2","S2"
)

# 6. Simulate latent exam performance for 100 students
exam_scores <- lapply(1:n_exams, function(i) {
  
  # Latent ability (harder distribution)
  ability <- rnorm(
    n_students,
    mean = runif(1, 20, 26),   # difficulty varies by exam
    sd   = runif(1, 4, 6) 
    # comment: it is not clear why variability also increases with grades; overall the grade simulation is quite unrealistics
  )
  
  # Observed exam outcome
  observed <- ifelse(
    ability < 18,
    0,                              # failed exam
    pmin(round(ability), 30)        # passed exam
  )
  
  observed
})

exam_scores_df <- as.data.frame(exam_scores)
colnames(exam_scores_df) <- paste0("Exam_", 1:n_exams)

# 7. Empirical probability of passing
p_pass <- sapply(exam_scores_df, function(x) mean(x > 0))

# 8. Exam-level grade (conditional on passing)
# This is NOT a sample mean: it is an exam parameter
exam_grade <- round(rnorm(n_exams, mean = 26, sd = 2))
exam_grade <- pmin(pmax(exam_grade, 18), 30)

grade <- c(exam_grade, rep(NA, n_seminars))
p_pass_all <- c(round(p_pass, 3), rep(1, n_seminars))

# 9. Assign grades and probabilities to all activities
grade <- c(exam_grade, rep(NA, n_seminars))
p_pass_all <- c(round(p_pass, 3), rep(1, n_seminars))

# 10. Lecture hours (only exams)
lecture_hours <- c(cfu[1:n_exams] * 6, rep(0, n_seminars))

# 11. Personal study hours
study_hours_exams <- round(runif(n_exams, 35, 80))
study_hours_seminars <- round(runif(n_seminars, 10, 25))
study_hours <- c(study_hours_exams, study_hours_seminars)

# 12. Special case: 12 CFU exam → 150 total hours
idx_12cfu <- which(cfu == 12)
study_hours[idx_12cfu] <- 150 - lecture_hours[idx_12cfu]

# 13. Total time
total_time <- lecture_hours + study_hours

# 14. Expected grade
expected_grade <- ifelse(
  is.na(grade),
  0,
  round(p_pass_all * grade, 2)
)

# 15. Efficiency
efficiency <- round((expected_grade * cfu) / total_time, 4)

# 16. Final dataset
data <- data.frame(
  activity,
  cfu,
  semester,
  p_pass = p_pass_all,
  grade,
  lecture_hours,
  study_hours,
  total_time,
  expected_grade,
  efficiency
)

# 17. Output
data

# 18. Optional: visualize full uncertainty
View(exam_scores_df)
