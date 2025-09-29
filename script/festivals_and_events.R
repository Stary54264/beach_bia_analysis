library(opendatatoronto)
library(tidyverse)

# get package
package <- show_package("9201059e-43ed-4369-885e-0b867652feac")
package

# get all resources
resources <- list_package_resources("9201059e-43ed-4369-885e-0b867652feac")

# get dataset
data <- get_resource(resources[1, ])$value

# write data to csv file
write_csv(data, "data/festivals_and_events.csv")
