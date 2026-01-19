# load packages
library(opendatatoronto)
library(tidyverse)


# download event dataset
event <- get_resource("8900fdb2-7f6c-4f50-8581-b463311ff05d")[[1]]
event_full <- event |>
  unnest(event_locations) |>
  mutate(
    geo_lat = as.numeric(str_extract(location_gps, '(?<="gps_lat":)[0-9.-]+')),
    geo_long = as.numeric(str_extract(location_gps, '(?<="gps_lng":)[0-9.-]+'))
  )


# write raw dataset to rds file
write_rds(event_full, "data/00_event_raw.rds")


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
write_rds(polygon, "data/01_area.rds")
