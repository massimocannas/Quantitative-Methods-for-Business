#Set the seed for reproducibility to ensure the same results in every simulation
set.seed(123)
#Define the list of bakery products
products <- c("Bread", "Festive_Sweets")
#Set selling prices and production costs per unit
price <- c(2.5, 6.0)
cost  <- c(1.2, 3.0)
#Define production time per unit (expressed in hours)
time_production <- c(0.05, 0.12)
#Simulate demand for a normal working day
demand_normal <- round(
  rnorm(2, mean = c(500, 120), sd = c(30, 20))
)
#Simulate demand for a festive period
demand_festive <- round(
  rnorm(2, mean = c(650, 300), sd = c(40, 50))
)
#Combine all simulated data and fixed parameters into a data frame
bakery_data <- data.frame(
  product = products,
  price = price,
  cost = cost,
  capacity_hours_per_unit = time_production,
  demand_normal = demand_normal,
  demand_festive = demand_festive
)
#Export the final dataset to a CSV file
write.csv(
  bakery_data,
  "production_data.csv",
  row.names = FALSE
)


