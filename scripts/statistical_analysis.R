# Statistical Analysis of Student Performance Data
# This R script performs statistical analysis on the sample dataset

# Load required libraries
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("corrplot")) install.packages("corrplot")

library(tidyverse)
library(ggplot2)
library(corrplot)

# Set working directory and load data
# setwd("path/to/project")
data <- read.csv("../data/sample_data.csv")

# Display basic information about the dataset
cat("Dataset Overview\n")
cat("================\n\n")

cat("Dataset Structure:\n")
str(data)

cat("\nDataset Summary:\n")
summary(data)

cat("\nFirst 6 rows:\n")
head(data)

# Basic Statistics
cat("\n\nDescriptive Statistics\n")
cat("======================\n\n")

# Mean values
cat("Mean GPA:", mean(data$gpa), "\n")
cat("Mean Attendance:", mean(data$attendance), "\n")
cat("Mean Study Hours:", mean(data$study_hours), "\n")
cat("Mean Exam Score:", mean(data$exam_score), "\n")

# Standard deviations
cat("\nStandard Deviations:\n")
cat("GPA SD:", sd(data$gpa), "\n")
cat("Attendance SD:", sd(data$attendance), "\n")
cat("Study Hours SD:", sd(data$study_hours), "\n")
cat("Exam Score SD:", sd(data$exam_score), "\n")

# Group by course analysis
cat("\n\nAnalysis by Course\n")
cat("==================\n\n")

course_summary <- data %>%
  group_by(course) %>%
  summarise(
    count = n(),
    avg_gpa = mean(gpa),
    avg_attendance = mean(attendance),
    avg_study_hours = mean(study_hours),
    avg_exam_score = mean(exam_score)
  )

print(course_summary)

# Gender analysis
cat("\n\nAnalysis by Gender\n")
cat("==================\n\n")

gender_summary <- data %>%
  group_by(gender) %>%
  summarise(
    count = n(),
    avg_gpa = mean(gpa),
    avg_exam_score = mean(exam_score)
  )

print(gender_summary)

# Correlation Analysis
cat("\n\nCorrelation Analysis\n")
cat("====================\n\n")

numeric_data <- data[, c("age", "gpa", "attendance", "study_hours", "exam_score")]
correlation_matrix <- cor(numeric_data)

cat("Correlation Matrix:\n")
print(round(correlation_matrix, 3))

# Key correlations
cat("\nKey Correlations:\n")
cat("Study Hours vs Exam Score:", cor(data$study_hours, data$exam_score), "\n")
cat("Attendance vs GPA:", cor(data$attendance, data$gpa), "\n")
cat("GPA vs Exam Score:", cor(data$gpa, data$exam_score), "\n")

# T-test: Gender difference in exam scores
cat("\n\nHypothesis Testing\n")
cat("==================\n\n")

cat("T-test: Gender difference in exam scores\n")
t_test_result <- t.test(exam_score ~ gender, data = data)
print(t_test_result)

# ANOVA: Course difference in exam scores
cat("\nANOVA: Course difference in exam scores\n")
anova_result <- aov(exam_score ~ course, data = data)
print(summary(anova_result))

# Linear Regression
cat("\n\nLinear Regression Analysis\n")
cat("==========================\n\n")

cat("Predicting Exam Score based on Study Hours and Attendance:\n")
model <- lm(exam_score ~ study_hours + attendance, data = data)
print(summary(model))

cat("\n\nAnalysis Complete!\n")
