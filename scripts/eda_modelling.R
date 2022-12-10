# Load libraries
library(tidyverse)
library(data.table)
library(ggplot2)

# Read data
df_raw <- read.csv("data/train.csv") %>%
  setDT()

# EDA

# Data overview
head(df_raw)

# Date range
range(df_raw$date)

# Unique stores in data
n_distinct(df_raw$store)

# Unique items in data
n_distinct(df_raw$item)

# Histogram of sales
df_raw %>%
  ggplot(aes(x = sales)) +
  geom_histogram()

# Histogram of log sales
df_raw %>%
  ggplot(aes(x = log(sales))) +
  geom_histogram()

# Feature extraction

# copy df_raw %>%
# convert `item` to factor %>%
# convert `store` to factor %>%
# extract day of the month using lubridate::day() and convert to factor %>%
# extract day of the month using lubridate::day() and convert to factor %>%
# extract month using lubridate::month() and convert to factor %>%
# extract day of the week using lubridate::wday() and convert to factor

df <- df_raw %>%
  copy() %>%
  .[, item := as.factor(item)] %>%
  .[, store := as.factor(store)] %>%
  .[, day := as.factor(lubridate::day(date))] %>%
  .[, month := as.factor(lubridate::month(date))] %>%
  .[, day_of_week := as.factor(lubridate::wday(date))]

# Plot average sales per day of the week
df %>%
  .[, .(avg_sales = mean(sales, na.rm = T)), .(day_of_week)] %>%
  ggplot(aes(x = day_of_week, y = avg_sales)) +
  geom_col()

# Select features to use for training
df_train <- df %>%
  .[, .(store, item, sales, day, month, day_of_week)]

# Train first regression model
# sales = store + item + sales + day + month + day_of_week
lm_1 <- lm(sales ~ ., df_train)
# summary(lm_1)

# Train second regression model
# sales = store + item + sales + day + month + day_of_week
lm_2 <- lm(log(sales + 0.01) ~ ., df_train)
# summary(lm_2)

# Save models
lm_1 %>%
  saveRDS("api/lm_1.rds")

lm_2 %>%
  saveRDS("api/lm_2.rds")

# Create a test set 
set.seed(23)
df_test <- df_raw[sample(nrow(df_raw), 10),]

# Save test data
df_test %>%
  saveRDS("data/df_test.rds")
