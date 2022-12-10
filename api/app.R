#> Load libraries in correct order ----
library(data.table)
library(tidyverse)
library(lubridate)
library(jsonlite)

#* Return "Hello world!"
#* @get /hello
function() {
  "Hello world!"
}


#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg="") {
  list(msg = paste0("The message is: '", msg, "'"))
}

#* Return the sum of two numbers
#* @param a The first number to add
#* @param b The second number to add
#* @post /sum
function(a, b) {
  as.numeric(a) + as.numeric(b)
}

#* Return predictions based on submitted data
#* @post /prediction
function(req) {
  # Load model
  model <-  readRDS("lm_1.rds")
  
  # Ingest data into dataframe
  df_raw <- fromJSON(req$postBody) %>% 
    as.data.frame() %>% 
    setDT()
  
  # Copy raw data into df
  df <- df_raw %>% 
    copy()
  
  # Pre-processing
  df %>% 
    .[, item := as.factor(item)] %>% 
    .[, store := as.factor(store)] %>% 
    .[, day := as.factor(lubridate::day(date))] %>% 
    .[, month := as.factor(lubridate::month(date))] %>% 
    .[, day_of_week := as.factor(lubridate::wday(date))] 
  
  # Dealing with new factors
  model$xlevels[["item"]] <- union(model$xlevels[["item"]], levels(df$item))
  
  # YOUR TURN: Adjust model levels for variable `store`
  
  # Add the predictions to the dataframe
  df_raw %>% 
   .[, predicted_sales := predict(model, df)]
 
 return(df_raw)
  
}

# YOUR TURN: create an endpoint that predicts sales based on our second model

#* @post /log_prediction
function(req) {
  # Load model

  # Ingest data into dataframe
  df_raw <- fromJSON(req$postBody) %>% 
    as.data.frame() %>% 
    setDT()
  
  # Copy raw data into df
  df <- df_raw %>% 
    copy()
  
  # Pre-processing
  
  # Dealing with new factors
  
  # Add the predictions to the dataframe
  # Remember: the result is "logged". Hint: use exp()
  
  return(df_raw)
}