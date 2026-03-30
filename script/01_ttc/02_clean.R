# load packages
library(tidyverse)


# read dataset
beach_filtered <- read_rds("data/01_ttc/01_beach_filtered.rds")
park_filtered <- read_rds("data/01_ttc/02_park_filtered.rds")


# clean dataset
beach_clean <- beach_filtered |>
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

park_clean <- park_filtered |>
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
write_rds(beach_clean, "data/01_ttc/03_beach_clean.rds")
write_rds(park_clean, "data/01_ttc/04_park_clean.rds")
