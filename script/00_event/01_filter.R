# load packages
library(sf)
library(tidyverse)


# read dataset
event_full <- read_rds("data/00_event/00_event_raw.rds")
polygon <- read_rds("data/00_event/01_area.rds")


# select beach data
event_sf <- event_full |>
  filter(!is.na(geo_lat), !is.na(geo_long)) |>
  st_as_sf(coords = c("geo_long", "geo_lat"), crs = 4326)

event_filtered <- event_sf |>
  st_filter(polygon, .predicate = st_within)


# write filtered dataset to rds file
write_rds(event_filtered, "data/00_event/02_event_filtered.rds")
