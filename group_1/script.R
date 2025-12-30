############################################
# QM PROJECT – ANALYSIS SCRIPT
############################################

### 1. CLEAN ENVIRONMENT
rm(list = ls())
set.seed(123)

### 2. LOAD LIBRARIES
library(ggplot2)

### 3. LOAD DATA
load("data/data.Rdata")

# Quick check
str(data)

############################################
### 4. DATA PREPARATION
############################################

# Separate exams and seminars
exams <- subset(data, type == "Exam")
seminars <- subset(data, type == "Seminar")

############################################
### 5. DESCRIPTIVE ANALYSIS
############################################

# Summary statistics
summary(exams)
summary(seminars)

# Number of activities by semester
table(data$semester)

# Exams vs seminars
table(data$type)

############################################
### 6. UNCERTAINTY ANALYSIS
############################################

# Histogram: probability of passing exams
hist_plot <- ggplot(exams, aes(x = p_pass)) +
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

print(hist_plot)

############################################
### 7. EXPECTED PERFORMANCE
############################################

# Scatter plot: expected grade vs probability of passing
scatter_plot <- ggplot(
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

print(scatter_plot)

############################################
### 8. EFFICIENCY ANALYSIS
############################################

# Order exams by efficiency
exams_efficiency <- exams[order(-exams$efficiency), ]

# Bar plot: efficiency by exam
eff_plot <- ggplot(
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

print(eff_plot)

############################################
### 9. SEMESTER COMPARISON
############################################

semester_plot <- ggplot(
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

print(semester_plot)
