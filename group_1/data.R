############################################
# QM PROJECT – DATASET
############################################

# 1. Clean environment and set seed
rm(list = ls())
set.seed(123)

############################################
# 2. GENERAL PARAMETERS
############################################
n_students <- 100
n_exams <- 10
n_seminars <- 4

############################################
# 3. ACTIVITIES
############################################
activity <- c(
  paste0("Exam_", 1:n_exams),
  paste0("Seminar_", 1:n_seminars)
)

############################################
# 4. CFU STRUCTURE
############################################
# Exams: 6, 9, and 12 CFU
cfu_exams <- c(6,6,6,9,6,6,9,9,9,12)

# Seminars: 2 or 3 CFU
cfu_seminars <- c(2,3,2,3)

cfu <- c(cfu_exams, cfu_seminars)

############################################
# 5. SEMESTER DISTRIBUTION
############################################
semester <- c(
  # Exams
  "S1","S1","S1","S1",          # 3x6 CFU + 1x9 CFU
  "S2","S2","S2","S2","S2","S2", # remaining exams incl. 12 CFU
  # Seminars
  "S1","S1","S2","S2"
)

############################################
# 6. SIMULATE STUDENT PERFORMANCE (UNCERTAINTY)
############################################
# Generate grades for 100 students per exam
exam_scores <- lapply(1:n_exams, function(i) {
  round(rnorm(
    n_students,
    mean = sample(22:28, 1),
    sd = 3
  ))
})

exam_scores_df <- as.data.frame(exam_scores)
colnames(exam_scores_df) <- paste0("Exam_", 1:n_exams)

# Truncate grades between 18 and 30
exam_scores_df <- pmin(pmax(exam_scores_df, 18), 30)

############################################
# 7. EXAM STATISTICS
############################################
mean_grade <- sapply(exam_scores_df, mean)
p_pass <- sapply(exam_scores_df, function(x) mean(x >= 18))

############################################
# 8. ASSIGN GRADES AND PROBABILITIES
############################################
grade <- c(round(mean_grade, 1), rep(NA, n_seminars))
p_pass_all <- c(round(p_pass, 3), rep(1, n_seminars))  # seminars always pass

############################################
# 9. TIME REQUIREMENTS
############################################
# Lecture hours: 6 per CFU for exams
lecture_hours_exams <- cfu_exams * 6
lecture_hours_seminars <- rep(0, n_seminars)
lecture_hours <- c(lecture_hours_exams, lecture_hours_seminars)

# Study hours (random)
study_hours_exams <- sample(40:80, n_exams, replace = TRUE)
study_hours_seminars <- sample(10:25, n_seminars, replace = TRUE)

# Special case: 12 CFU exam requires 150 total hours
idx_12cfu <- which(cfu_exams == 12)
study_hours_exams[idx_12cfu] <- 150 - lecture_hours_exams[idx_12cfu]

study_hours <- c(study_hours_exams, study_hours_seminars)

############################################
# 10. TOTAL TIME
############################################
total_time <- lecture_hours + study_hours

############################################
# 11. EXPECTED GRADE (STOCHASTIC)
############################################
expected_grade <- ifelse(
  is.na(grade),
  0,
  grade * p_pass_all
)

############################################
# 12. EFFICIENCY
############################################
efficiency <- (expected_grade * cfu) / total_time

############################################
# 13. TYPE VARIABLE
############################################
type <- ifelse(cfu >= 6, "Exam", "Seminar")

############################################
# 14. FINAL DATASET
############################################
data <- data.frame(
  activity,
  cfu,
  semester,
  type,
  grade,
  p_pass = p_pass_all,
  lecture_hours,
  study_hours,
  total_time,
  expected_grade,
  efficiency
)

############################################
# 15. SAVE DATASET
############################################
if(!dir.exists("data")) dir.create("data")
save(data, exam_scores_df, file = "data/data.Rdata")

# Visualize simulated student grades
View(exam_scores_df)
