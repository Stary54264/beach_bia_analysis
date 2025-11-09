# load packages
library(opendatatoronto)
library(sf)
library(tidyverse)


# # download event dataset
# event <- get_resource("8900fdb2-7f6c-4f50-8581-b463311ff05d")[[1]]
# event_full <- event |>
#   unnest(event_locations) |>
#   mutate(
#     geo_lat = as.numeric(str_extract(location_gps, '(?<="gps_lat":)[0-9.-]+')),
#     geo_long = as.numeric(str_extract(location_gps, '(?<="gps_lng":)[0-9.-]+'))
#   )
# 
# 
# # write raw dataset to rds file
# write_rds(event_full, "data/event_raw.rds")


# read dataset
event_full <- read_rds("data/event_raw.rds")


# get the beach area
polygon <- list_package_resources("fc443770-ef0a-4025-9c2c-2cb558bfab00") |>
  filter(tolower(format) %in% c('csv', 'geojson')) |>
  filter(row_number()==1) |>
  get_resource() |>
  filter(AREA_SHORT_CODE %in% c("063", "070")) |>
  st_as_sf() |>
  st_set_crs(4326) |>
  select(geometry)


# write area data to rds file
write_rds(polygon, "data/area.rds")


# select beach data
event_sf <- event_full |>
  filter(!is.na(geo_lat), !is.na(geo_long)) |>
  st_as_sf(coords = c("geo_long", "geo_lat"), crs = 4326)

event_filtered <- event_sf |>
  st_filter(polygon, .predicate = st_within)


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
  filter(format(dat, "%Y") == "2025")


# write cleaned dataset to rds file
write_rds(event_clean, "data/event_clean.rds")
