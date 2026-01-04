############################################
# QM PROJECT – DATASET GENERATION
############################################

# 1. Clean environment and set seed
rm(list = ls())
set.seed(123)

############################################
# 2. GENERAL PARAMETERS
############################################
n_exams     <- 10
n_seminars <- 4
n_students <- 100

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
cfu_exams     <- c(6,6,6,9,6,6,9,9,9,12)
cfu_seminars <- c(2,3,2,3)
cfu <- c(cfu_exams, cfu_seminars)

############################################
# 5. SEMESTER DISTRIBUTION
############################################
semester <- c(
  "S1","S1","S1","S1",              # exams S1
  "S2","S2","S2","S2","S2","S2",     # exams S2
  "S1","S1","S2","S2"                # seminars
)

############################################
# 6. TYPE
############################################
type <- ifelse(cfu >= 6, "Exam", "Seminar")

############################################
# 7. UNCERTAINTY: PROBABILITY OF PASSING
############################################
# Exams: uncertain probability (Beta distribution)
p_pass_exams <- rbeta(n_exams, shape1 = 5, shape2 = 3)

# Seminars: always passed
p_pass_seminars <- rep(1, n_seminars)

p_pass <- c(p_pass_exams, p_pass_seminars)

############################################
# 8. CONDITIONAL GRADES (IF PASSED)
############################################
# Expected grade conditional on passing
grade_exams <- round(rnorm(n_exams, mean = 26, sd = 2))
grade_exams <- pmin(pmax(grade_exams, 18), 30)

grade <- c(grade_exams, rep(NA, n_seminars))

############################################
# 9. TIME REQUIREMENTS
############################################
# Lecture hours
lecture_hours_exams     <- cfu_exams * 6
lecture_hours_seminars <- rep(0, n_seminars)
lecture_hours <- c(lecture_hours_exams, lecture_hours_seminars)

# Study hours
study_hours_exams     <- sample(40:80, n_exams, replace = TRUE)
study_hours_seminars <- sample(10:25, n_seminars, replace = TRUE)

# Special case: 12 CFU exam → 150 total hours
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
  grade * p_pass
)

############################################
# 12. EFFICIENCY
############################################
efficiency <- (expected_grade * cfu) / total_time

############################################
# 13. FINAL DATASET
############################################
data <- data.frame(
  activity,
  type,
  cfu,
  semester,
  grade,
  p_pass,
  lecture_hours,
  study_hours,
  total_time,
  expected_grade,
  efficiency
)

############################################
# 14. SAVE DATASET
############################################
if (!dir.exists("data")) dir.create("data")
save(data, file = "data/data.Rdata")

############################################
# 15. CHECK
############################################
View(data)
