## To run this script, please set the working directory to the source file location (In RStudio: Session > Set Working Directory > To Source File Location).
# Library
library(lpSolve)
library(dplyr)
library(readxl)
library(tidyr)
library(ggplot2)
library(patchwork)
library(scales)

# Import Data
file_path <- "data.xlsx"
data <- read_excel(file_path)
View(data)

# 1. Cleaning dataset
data$product <- trimws(data$product)

data <- data %>%
  fill(date, `available time per day(h)`, .direction = "down") %>%
  mutate(
    date = as.Date(date),
    period = ifelse(format(date, "%d") >= "15", "Christmas", "Normal")
  )

# 2. Total consumption
data <- data %>%
  mutate(
    total_flour_used = flour * `quantity produced`,
    total_yeast_used = yeast * `quantity produced`
  )

# Division dataset
data_normal <- filter(data, period == "Normal")
data_christmas <- filter(data, period == "Christmas")

# 2. Optimizaiton functions

# LP function
build_lp_data <- function(df, demand_growth = 1.0) {
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

# Extraction for plot
get_lp_results <- function(lp_data, F_limit, L_limit, W_limit, scenario_name) {
  objective <- lp_data$price - lp_data$costs
  
  # Matrix
  const.mat <- matrix(
    c(lp_data$flour, lp_data$yeast, lp_data$time, 1, 0, 0, 1),
    nrow = 5, byrow = TRUE
  )
  
  const.dir <- c("<=", "<=", "<=", "<=", "<=")
  const.rhs <- c(F_limit, L_limit, W_limit, lp_data$demand[1], lp_data$demand[2])
  
  res <- lp("max", objective, const.mat, const.dir, const.rhs)
  
  return(list(
    scenario = scenario_name,
    sol = res$solution,
    profit = res$objval,
    lp_data = lp_data,
    limits = const.rhs
  ))
}

# Maximum constraints (75° percentile (flour and yeast) and mean (working hours))
daily_materials <- data %>%
  group_by(date, period) %>%
  summarise(
    day_flour = sum(total_flour_used, na.rm = TRUE),
    day_yeast = sum(total_yeast_used, na.rm = TRUE),
    .groups = "drop"
  )

daily_time <- data %>%
  group_by(period) %>%
  summarise(
    W_cap = mean(`available time per day(h)`[`available time per day(h)` > 0], na.rm = TRUE)
  )

limits_materials <- daily_materials %>%
  group_by(period) %>%
  summarise(
    F_cap = quantile(day_flour, 0.75, na.rm = TRUE),
    L_cap = quantile(day_yeast, 0.75, na.rm = TRUE)
  )

limits <- left_join(limits_materials, daily_time, by = "period")
lim_norm <- filter(limits, period == "Normal")
lim_xmas <- filter(limits, period == "Christmas")

# Scenarios
lp_norm_std  <- build_lp_data(data_normal, 1.0)
lp_xmas_std  <- build_lp_data(data_christmas, 1.0)
lp_norm_plus <- build_lp_data(data_normal, 1.15)
lp_xmas_plus <- build_lp_data(data_christmas, 1.15)

# Final results
res_norm_std  <- get_lp_results(lp_norm_std, lim_norm$F_cap, lim_norm$L_cap, lim_norm$W_cap, "Normal")
res_xmas_std  <- get_lp_results(lp_xmas_std, lim_xmas$F_cap, lim_xmas$L_cap, lim_xmas$W_cap, "Festive")
res_norm_plus <- get_lp_results(lp_norm_plus, lim_norm$F_cap, lim_norm$L_cap, lim_norm$W_cap, "Normal +15%")
res_xmas_plus <- get_lp_results(lp_xmas_plus, lim_xmas$F_cap, lim_xmas$L_cap, lim_xmas$W_cap, "Festive +15%")

# 3. PLOT

# A. intersections plot
plot_optimization_styled <- function(res_obj) {
  d <- res_obj$lp_data
  lim <- res_obj$limits
  sol <- res_obj$sol
  
  x_max <- max(lim[4] * 1.5, sol[1] * 2)
  y_max <- max(lim[5] * 2, sol[2] * 4)
  
  ggplot() +
    geom_abline(aes(intercept = lim[1]/d$flour[2], slope = -d$flour[1]/d$flour[2], color = "Flour"), size = 1) +
    geom_abline(aes(intercept = lim[2]/d$yeast[2], slope = -d$yeast[1]/d$yeast[2], color = "Yeast"), size = 1) +
    geom_abline(aes(intercept = lim[3]/d$time[2], slope = -d$time[1]/d$time[2], color = "Time"), size = 1) +
    geom_vline(aes(xintercept = lim[4], color = "Max Demand Bread"), linetype = "dashed", size = 0.8) +
    geom_hline(aes(yintercept = lim[5], color = "Max Demand Sweets"), linetype = "dashed", size = 0.8) +
    geom_point(aes(x = sol[1], y = sol[2]), color = "red", size = 4) +
    annotate("label", x = x_max * 0.7, y = y_max * 0.85, 
             label = paste0("OPTIMAL\nbread: ", round(sol[1], 2), 
                            "\nsweets: ", round(sol[2], 2), 
                            "\nProfit: €", round(res_obj$profit, 2)),
             fill = "white", color = "black", fontface = "bold", size = 3) +
    labs(title = paste("Optimization:", res_obj$scenario),
         subtitle = "The red intersection indicates the optimal production mix",
         x = "Quantity bread", y = "Quantity sweets",
         color = "Constraints") +
    scale_color_manual(values = c("Flour"="#f8766d", "Yeast"="#7cae00", "Time"="#c77cff", 
                                  "Max Demand Bread"="#00bfc4", "Max Demand Sweets"="black")) +
    coord_cartesian(xlim = c(0, x_max), ylim = c(0, y_max)) +
    theme_minimal() +
    theme(legend.position = "right", plot.title = element_text(size = 14, face = "bold"))
}


# plot optimization
p1 <- plot_optimization_styled(res_norm_std)
p2 <- plot_optimization_styled(res_norm_plus)
p3 <- plot_optimization_styled(res_xmas_std)
p4 <- plot_optimization_styled(res_xmas_plus)

# 1. Single plot
p1 # Normal
p2 # Normal +15
p3 # Festive
p4 # Festive +15

# 2. Compared plot (Normal vs Normal +15% e Festive vs Festive +15%)
(p1 + p2) + plot_annotation(title = "Comparison: Normal vs Normal +15%")
(p3 + p4) + plot_annotation(title = "Comparison: Festive vs Festive +15%")

# 3. Compared plot 2x2 scenarios
(p1 | p2) / (p3 | p4) + plot_annotation(title = "All Optimization Scenarios")


# 5. Compared total profit
df_all_profits <- data.frame(
  Scenario = factor(c("N", "N+15%", "F", "F+15%"), 
                    levels = c("N", "N+15%", "F", "F+15%")),
  Profit = c(res_norm_std$profit, res_norm_plus$profit, res_xmas_std$profit, res_xmas_plus$profit)
)

ggplot(df_all_profits, aes(x = Scenario, y = Profit, fill = Scenario)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = paste("€", round(Profit, 2))), vjust = -0.3) +
  labs(title = "Max Profit Comparison: All Scenarios", y = "Profit (€)") +
  theme_minimal()

# Max Daily Profit Comparison (Base)

df_profit_base <- data.frame(
  Scenario = factor(c("Normal", "Festive"), levels = c("Normal", "Festive")),
  Profit = c(res_norm_std$profit, res_xmas_std$profit)
)

# Plot
ggplot(df_profit_base, aes(x = Scenario, y = Profit, fill = Scenario)) +
  geom_bar(stat = "identity", width = 0.7) +
  geom_text(aes(label = round(Profit, 2)), vjust = -0.5, fontface = "bold") +
  scale_fill_manual(values = c("Normal" = "#f8766d", "Festive" = "#00bfc4")) +
  labs(title = "Max Daily Profit Comparison", 
       y = "Profit (€)", 
       x = "Scenario") +
  theme_minimal() +
  theme(legend.position = "right")


# Optimal Production Mix
get_mix_df <- function(res_obj, label) {
  data.frame(
    Scenario = label,
    Product = res_obj$lp_data$product,
    Quantity = res_obj$sol
  )
}

# Compared optimal production mix
df_mix_all <- rbind(
  get_mix_df(res_norm_std, "N"),
  get_mix_df(res_norm_plus, "N+15%"),
  get_mix_df(res_xmas_std, "F"),
  get_mix_df(res_xmas_plus, "F+15%")
)

# A. Comparative mix plot
ggplot(df_mix_all, aes(x = Scenario, y = Quantity, fill = Product)) +
  geom_bar(stat = "identity", position = "stack", width = 0.7) +
  scale_fill_manual(values = c("bread" = "#66c2a5", "sweets" = "#fc8d62")) +
  labs(title = "Optimal Production Mix", 
       subtitle = "Comparison across all scenarios",
       y = "Units Produced", 
       x = "Scenario") +
  theme_minimal()

# B. Single plot
ggplot(df_mix_all, aes(x = Product, y = Quantity, fill = Product)) +
  geom_bar(stat = "identity", width = 0.6) +
  geom_text(aes(label = round(Quantity, 0)), vjust = -0.5) +
  facet_wrap(~Scenario) +
  scale_fill_manual(values = c("bread" = "#66c2a5", "sweets" = "#fc8d62")) +
  labs(title = "Optimal Production Mix by Scenario", 
       y = "Units") +
  theme_light() +
  theme(legend.position = "none")

# Saturation

plot_saturation_styled <- function(res_obj, title_suffix) {
  used_f <- sum(res_obj$sol * res_obj$lp_data$flour)
  used_y <- sum(res_obj$sol * res_obj$lp_data$yeast)
  used_t <- sum(res_obj$sol * res_obj$lp_data$time)
  
  df_sat <- data.frame(
    Resource = c("Flour", "Yeast", "Time"),
    Usage = c(used_f/res_obj$limits[1], used_y/res_obj$limits[2], used_t/res_obj$limits[3]) * 100
  )
  
  ggplot(df_sat, aes(x = Resource, y = Usage, fill = Usage)) +
    geom_bar(stat = "identity", width = 0.8) +
    scale_fill_gradientn(colors = c("#56B4E9", "#F0E442", "#D55E00"), 
                         limits = c(0, 100), 
                         na.value = "#D55E00") + 
    geom_hline(yintercept = 100, linetype = "dashed", color = "red", size = 1) +
    scale_y_continuous(limits = c(0, 115)) +
    labs(title = paste("Resource Saturation", title_suffix),
         y = "Percentage Used (%)", x = "") +
    theme_minimal() +
    geom_text(aes(label = paste0(round(Usage, 1), "%")), vjust = -0.5, fontface = "bold")
}

# A. Standard Scenario (Normal vs Festive)
df_sat_std <- rbind(
  plot_saturation_styled(res_norm_std, "") %>% .$data %>% mutate(Scenario = "Normal"),
  plot_saturation_styled(res_xmas_std, "") %>% .$data %>% mutate(Scenario = "Festive")
)

plot_std <- ggplot(df_sat_std, aes(x = Resource, y = Usage, fill = Usage)) +
  geom_bar(stat = "identity", width = 0.7) +
  scale_fill_gradientn(colors = c("#56B4E9", "#F0E442", "#D55E00"), limits = c(0, 100), na.value = "#D55E00") +
  geom_hline(yintercept = 100, linetype = "dashed", color = "red") +
  facet_wrap(~Scenario) +
  labs(title = "Resource Saturation: Standard Scenarios", y = "Usage (%)") +
  theme_minimal() +
  geom_text(aes(label = paste0(round(Usage, 1), "%")), vjust = -0.5, fontface = "bold", size = 3)

# B. +15% Scenario (Normal +15% vs Festive +15%)
df_sat_plus <- rbind(
  plot_saturation_styled(res_norm_plus, "") %>% .$data %>% mutate(Scenario = "Normal +15%"),
  plot_saturation_styled(res_xmas_plus, "") %>% .$data %>% mutate(Scenario = "Festive +15%")
)

plot_plus <- ggplot(df_sat_plus, aes(x = Resource, y = Usage, fill = Usage)) +
  geom_bar(stat = "identity", width = 0.7) +
  scale_fill_gradientn(colors = c("#56B4E9", "#F0E442", "#D55E00"), limits = c(0, 100), na.value = "#D55E00") +
  geom_hline(yintercept = 100, linetype = "dashed", color = "red") +
  facet_wrap(~Scenario) +
  labs(title = "Resource Saturation: Scenarios +15% Demand", y = "Usage (%)") +
  theme_minimal() +
  geom_text(aes(label = paste0(round(Usage, 1), "%")), vjust = -0.5, fontface = "bold", size = 3)

# Visual
plot_std
plot_plus

