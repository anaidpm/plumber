# Installing the packages
# install.packages("httr")
# install.packages("jsonlite")

# Loading packages
library(httr)
library(jsonlite)
library(tidyverse)

# Read test data
df <- readRDS("data/df_test.rds")

df_test <- df %>% 
  select(-sales)

# Convert R object to JSON using jsonlite::toJSON()
body <- toJSON(df_test)

# Initializing API Call

# Set URL
url <- "http://127.0.0.1:8000/prediction"

# Post test data to API using httr::POST() and save the API's response in `result`
result <- POST(url, body = body, encode = "json")

# Print the response's status
result$status_code

if(result$status_code == 200){
  df_results <- fromJSON(toJSON(content(result)))
  
  mae <- mean(abs(as.numeric(df_results$predicted_sales) - as.numeric(df$sales)))
  
  print(paste0("Mean Absolute Error: ", mae))
  
  # plot scatter plot
  plot(df$sales,df_results$predicted_sales,
       main='Actual Sales vs. Predicted Sales',
       xlab='Sales', ylab='Predictions')
}

# YOUR TURN: remove the `item` column from df_test then call the API using the new dataframe
# What it the response's status?