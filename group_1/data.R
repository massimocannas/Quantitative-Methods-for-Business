############################################
# COMPLETE DATASET – QM PROJECT (ENGLISH)
############################################

# 1. Clean environment and set seed
rm(list = ls())
set.seed(123)

# 2. General parameters
n_students <- 100
n_exams <- 10
n_seminars <- 4

# 3. Define activities
activity <- c(paste0("Exam_", 1:n_exams), paste0("Seminar_", 1:n_seminars))

# 4. CFU
cfu <- c(6,6,6,9,6,6,9,9,9,6,  # 10 exams
         2,3,2,3)               # 4 seminars

# 5. Semester distribution
semester <- c(
  "S1","S1","S1","S1",  # first semester: 3x6 CFU + 1x9 CFU
  "S2","S2","S2","S2","S2","S2", # second semester: remaining exams
  "S1","S1","S2","S2"   # seminars
)

# 6. Simulate 100 student scores for each exam
exam_scores <- lapply(1:n_exams, function(x){
  round(rnorm(n_students, mean = sample(22:28,1), sd = 3))
})

exam_scores_df <- do.call(cbind, exam_scores)
colnames(exam_scores_df) <- paste0("Exam_",1:n_exams)

# 7. Truncate scores between 18 and 30
exam_scores_df <- pmin(pmax(exam_scores_df,18),30)

# 8. Calculate mean grades and probability of passing
mean_grade <- numeric(n_exams)
p_pass <- numeric(n_exams)

for(i in 1:n_exams){
  grades <- exam_scores_df[,i]
  mean_grade[i] <- mean(grades)
  p_pass[i] <- sum(grades >= 18)/length(grades)
}

# 9. Assign grade and p_pass to all activities
grade <- c(round(mean_grade), rep(NA, n_seminars))
p_pass_all <- c(p_pass, rep(1, n_seminars))

# 10. Lecture hours (only exams: 6 hours per CFU)
lecture_hours <- c(cfu[1:n_exams]*6, rep(0,n_seminars))

# 11. Personal study hours (random)
study_hours <- c(
  sample(30:70,n_exams,replace=TRUE),
  sample(10:25,n_seminars,replace=TRUE)
)

# 12. Special case: difficult exam 9 CFU in S1
idx_difficult <- which(cfu==9 & semester=="S1")
study_hours[idx_difficult] <- 120 - lecture_hours[idx_difficult] # total 120 hours

# 13. Total time
total_time <- lecture_hours + study_hours

# 14. Final dataset
data <- data.frame(
  activity,
  cfu,
  semester,
  p_pass = round(p_pass_all,3),
  grade = grade,
  lecture_hours,
  study_hours,
  total_time
)

# 15. Expected grade (only exams)
data$expected_grade <- ifelse(
  is.na(data$grade), 0,
  data$p_pass * data$grade * runif(nrow(data),0.9,1.1)
)

# 16. Efficiency
data$efficiency <- (data$expected_grade * data$cfu)/data$total_time

# 17. View dataset
data

# 18. Optional: see all 100 student scores
View(exam_scores_df)
