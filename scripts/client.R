# Installing the packages
install.packages("httr")
install.packages("jsonlite")

# Loading packages
library(httr)
library(jsonlite)

# Initializing API Call
url <- "http://127.0.0.1:8000/sum"

body <- list(a = 1, b = 2)

r <- POST(url, body = body, encode = "json")

r$status_code

if(r$status_code == 200){
  unlist(content(r))
}
       