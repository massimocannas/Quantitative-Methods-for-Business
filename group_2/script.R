library(lpSolve)
library(dplyr)
library(readxl)
library(tidyr)

data <- read_excel("C:/Users/franc/Desktop/International Management/QM/R/data.xlsx")
View(data)

# clean dataset data ---

data$product <- trimws(data$product)

data <- data %>%
  fill(date, `available time per day(h)`, .direction = "down") %>%
  mutate(
    date = as.Date(date),
    period = ifelse(format(date, "%d") >= "15", "Christmas", "Normal")
  )

# total used flour and yeast based on dataset ---
data <- data %>%
  mutate(
    total_flour_used = flour * `quantity produced`,
    total_yeast_used = yeast * `quantity produced`
  )

# division based on christmas and normal days
data_normal <- filter(data, period == "Normal")
data_christmas <- filter(data, period == "Christmas")

#calculate mean and max of demand
build_lp_data <- function(df) {
  df %>%
    group_by(product) %>%
    summarise(
      price  = mean(price, na.rm = TRUE),
      costs  = mean(costs, na.rm = TRUE),
      flour  = mean(flour, na.rm = TRUE),
      yeast  = mean(yeast, na.rm = TRUE),
      time   = mean(time, na.rm = TRUE),
      demand = max(demand, na.rm = TRUE)
    ) %>%
    arrange(product)
}

lp_normal_data <- build_lp_data(data_normal)
lp_christmas_data <- build_lp_data(data_christmas)

#solver function

solve_lp <- function(lp_data, F_limit, L_limit, W_limit) {

  objective <- lp_data$price - lp_data$costs
  #matrix
  const.mat <- matrix(
    c(
      lp_data$flour,   # Farina
      lp_data$yeast,   # Lievito
      lp_data$time,    # Tempo
      c(1, 0),         # Max Bread
      c(0, 1)          # Max Sweets
    ),
    nrow = 5, byrow = TRUE
  )

  #direction of constraints
  const.dir <- c("<=", "<=", "<=", "<=", "<=")
  const.rhs <- c(F_limit, L_limit, W_limit, lp_data$demand[1], lp_data$demand[2])

  res <- lp("max", objective, const.mat, const.dir, const.rhs)

  if(res$status == 0) {
    cat("Status: Optimal solution found\n")
    print(setNames(res$solution, lp_data$product))
    cat("Max daily profit: €", round(res$objval, 2), "\n")
  } else {
    cat("No solution (Codice:", res$status, ")\n")
  }
}

#capacity

# flour and yeast (75°)
daily_materials <- data %>%
  group_by(date, period) %>%
  summarise(
    day_flour = sum(total_flour_used, na.rm = TRUE),
    day_yeast = sum(total_yeast_used, na.rm = TRUE),
    .groups = "drop"
  )

# available time per day(working hours), excluding 25th december
daily_time <- data %>%
  group_by(period) %>%
  summarise(
    # mean of working hours
    W_cap = mean(`available time per day(h)`[`available time per day(h)` > 0], na.rm = TRUE)
  )

limits_materials <- daily_materials %>%
  group_by(period) %>%
  summarise(
    F_cap = quantile(day_flour, 0.75, na.rm = TRUE),
    L_cap = quantile(day_yeast, 0.75, na.rm = TRUE)
  )

# total limits
limits <- left_join(limits_materials, daily_time, by = "period")

print("--- NEW LIMITS ---")
print(limits)

# results

cat("\n--- Normal Days ---\n")
lim_norm <- filter(limits, period == "Normal")
solve_lp(lp_normal_data, lim_norm$F_cap, lim_norm$L_cap, lim_norm$W_cap)

cat("\n--- Festive Days ---\n")
lim_xmas <- filter(limits, period == "Christmas")
solve_lp(lp_christmas_data, lim_xmas$F_cap, lim_xmas$L_cap, lim_xmas$W_cap)

# 15% increase in demand
build_lp_data <- function(df, demand_growth = 1.15) {
  df %>%
    group_by(product) %>%
    summarise(
      price  = mean(price, na.rm = TRUE),
      costs  = mean(costs, na.rm = TRUE),
      flour  = mean(flour, na.rm = TRUE),
      yeast  = mean(yeast, na.rm = TRUE),
      time   = mean(time, na.rm = TRUE),
      demand = max(demand, na.rm = TRUE) * demand_growth
    ) %>%
    arrange(product)
}

# new lp
lp_normal_data    <- build_lp_data(data_normal, 1.15)
lp_christmas_data <- build_lp_data(data_christmas, 1.15)

# results

cat("\n--- Normal Days ---\n")
lim_norm <- filter(limits, period == "Normal")
solve_lp(lp_normal_data, lim_norm$F_cap, lim_norm$L_cap, lim_norm$W_cap)

cat("\n--- Festive Days ---\n")
lim_xmas <- filter(limits, period == "Christmas")
solve_lp(lp_christmas_data, lim_xmas$F_cap, lim_xmas$L_cap, lim_xmas$W_cap)
