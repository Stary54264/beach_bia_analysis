# load packages
library(tidyverse)


# read dataset
data_raw <- read_rds("data/01_ttc/00_raw.rds")


# select buses/streetcars that serves the beach BIA
data_filtered <- data_raw |>
  filter(Route %in% c(22, 31, 92, 503))


# write filtered dataset to rds file
write_rds(data_filtered, "data/01_ttc/01_filtered.rds")
