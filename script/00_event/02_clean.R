# load packages
library(tidyverse)


# read dataset
event_filtered <- read_rds("data/02_event_filtered.rds")


# clean dataset
event_clean <- event_filtered |>
  unnest(event_dates) |>
  mutate(
    dat = mdy(str_extract(sdate, "^[^-]+")),
  ) |>
  rename(
    name = event_name,
    categ = event_category,
    descript = short_description,
    free = free_event,
    feat = event_features,
    reserv = reservations_required,
    loc = geometry
  ) |>
  select(name, dat, categ, descript, free, feat, reserv, loc) |>
  filter(dat < "2026-02-01")


# write cleaned dataset to rds file
write_rds(event_clean, "data/03_event_clean.rds")
