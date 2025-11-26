# Data Visualization Script for Student Performance Analysis
# This R script creates visualizations for the student dataset

# Load required libraries
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("gridExtra")) install.packages("gridExtra")

library(ggplot2)
library(tidyverse)
library(gridExtra)

# Load data
data <- read.csv("../data/sample_data.csv")

# Create output directory for plots
dir.create("../reports", showWarnings = FALSE)

# 1. GPA Distribution Histogram
gpa_hist <- ggplot(data, aes(x = gpa)) +
  geom_histogram(bins = 10, fill = "steelblue", color = "black", alpha = 0.7) +
  labs(title = "Distribution of GPA",
       x = "GPA",
       y = "Frequency") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))

# 2. Exam Scores by Course (Box Plot)
exam_boxplot <- ggplot(data, aes(x = course, y = exam_score, fill = course)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Exam Scores by Course",
       x = "Course",
       y = "Exam Score") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        legend.position = "none")

# 3. Study Hours vs Exam Score (Scatter Plot)
study_scatter <- ggplot(data, aes(x = study_hours, y = exam_score)) +
  geom_point(color = "darkgreen", size = 3, alpha = 0.6) +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  labs(title = "Study Hours vs Exam Score",
       x = "Study Hours per Week",
       y = "Exam Score") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))

# 4. Attendance vs GPA (Scatter Plot)
attendance_scatter <- ggplot(data, aes(x = attendance, y = gpa)) +
  geom_point(color = "purple", size = 3, alpha = 0.6) +
  geom_smooth(method = "lm", color = "orange", se = TRUE) +
  labs(title = "Attendance vs GPA",
       x = "Attendance (%)",
       y = "GPA") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))

# Combine plots into a single figure
combined_plot <- grid.arrange(gpa_hist, exam_boxplot, 
                               study_scatter, attendance_scatter,
                               ncol = 2, nrow = 2)

# Save combined plot
ggsave("../reports/r_analysis_plots.png", combined_plot, width = 12, height = 10, dpi = 150)

# 5. Gender Distribution Bar Chart
gender_bar <- ggplot(data, aes(x = gender, fill = gender)) +
  geom_bar(alpha = 0.7, color = "black") +
  geom_text(stat = "count", aes(label = after_stat(count)), vjust = -0.5) +
  labs(title = "Gender Distribution",
       x = "Gender",
       y = "Count") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        legend.position = "none")

ggsave("../reports/gender_distribution.png", gender_bar, width = 6, height = 5, dpi = 150)

# 6. Course Distribution Pie Chart (as bar for better visualization)
course_bar <- ggplot(data, aes(x = course, fill = course)) +
  geom_bar(alpha = 0.7, color = "black") +
  geom_text(stat = "count", aes(label = after_stat(count)), vjust = -0.5) +
  labs(title = "Course Distribution",
       x = "Course",
       y = "Number of Students") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        legend.position = "none",
        axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("../reports/course_distribution.png", course_bar, width = 8, height = 6, dpi = 150)

# 7. Average Performance by Course
course_performance <- data %>%
  group_by(course) %>%
  summarise(
    avg_gpa = mean(gpa),
    avg_exam_score = mean(exam_score)
  ) %>%
  pivot_longer(cols = c(avg_gpa, avg_exam_score), 
               names_to = "metric", 
               values_to = "value")

performance_plot <- ggplot(course_performance, aes(x = course, y = value, fill = metric)) +
  geom_bar(stat = "identity", position = "dodge", alpha = 0.7) +
  labs(title = "Average Performance by Course",
       x = "Course",
       y = "Value",
       fill = "Metric") +
  scale_fill_manual(values = c("avg_gpa" = "#3498db", "avg_exam_score" = "#e74c3c"),
                    labels = c("Average GPA", "Average Exam Score")) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("../reports/performance_by_course.png", performance_plot, width = 10, height = 6, dpi = 150)

cat("All visualizations have been saved to the reports/ directory.\n")
