# load packages
library(opendatatoronto)
library(tidyverse)


# download bus and streetcar datasets
bus_22 <- get_resource("3b3c2673-5231-4aac-8b6a-dc558dce588c")
bus_23 <- get_resource("10802a64-9ac0-4f2e-9538-04800a399d1e")
bus_24 <- get_resource("7823b829-9952-4e4c-ac8f-0fe2ef53901c")
sc_22 <- get_resource("28547222-35fe-48b6-ac4b-ccc67d286393")
sc_23 <- get_resource("472d838d-e41a-4616-a11b-585d26d59777")
sc_24 <- get_resource("5f527714-2284-437b-958b-c02b6f21eb9d")


# combining the datasets
sc_22 <- sc_22 |> mutate(Line = as.numeric(Line))
sc_23 <- sc_23 |> mutate(Line = as.numeric(Line))

data <- bind_rows(bus_22, bus_23, bus_24, sc_22, sc_23, sc_24)


# write the dataset to rds file
write_rds(data, "data/01_ttc/00_raw.rds")
