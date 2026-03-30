# load packages
library(tidyverse)


# read dataset
data_raw <- read_rds("data/01_ttc/00_raw.rds")


# select buses/streetcars that serves the beach BIA
beach <- data_raw |>
  filter(Route %in% c(22, 64, 92, 501, 503))


# select buses/streetcars that serves the High Park
park <- data_raw |>
  filter(Route %in% c(30, 80, 203, 501, 506))


# write filtered dataset to rds file
write_rds(beach, "data/01_ttc/01_beach_filtered.rds")
write_rds(park, "data/01_ttc/02_park_filtered.rds")
