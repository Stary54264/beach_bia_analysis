# load packages
library(car)
library(tidyverse)


# read dataset
data <- read_rds("data/01_ttc/03_beach_clean.rds")


# select columns for modelling
data_model <- data |>
  mutate(month = relevel(as.factor(month(date)), ref = "1"),
         hour = relevel(factor(sub(":.*", "", time)), ref = "00"),
         day = relevel(as.factor(day), ref = "Sunday")
  ) |>
  select(dly, month, hour, day)


# build linear model
model <- lm(dly ~ month + hour + day, data = data_model)


# save the model to rds file
write_rds(model, "model/00_model.rds")

