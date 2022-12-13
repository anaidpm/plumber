library(plumber)
# 'app.R' is the location of the file shown above
pr("api/app.R") %>%
  pr_run(port=8000)
