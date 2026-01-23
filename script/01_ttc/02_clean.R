# load packages
library(tidyverse)


# read dataset
data_filtered <- read_rds("data/01_ttc/01_filtered.rds")


# clean dataset
data_clean <- data_filtered |>
  rename(
    date = Date,
    time = Time,
    day = Day,
    loc = Location,
    icd = Incident,
    dly = `Min Delay`,
    gap = `Min Gap`
  ) |>
  select(date, time, day, loc, icd, dly, gap)


# write cleaned dataset to rds file
write_rds(data_clean, "data/01_ttc/02_clean.rds")
