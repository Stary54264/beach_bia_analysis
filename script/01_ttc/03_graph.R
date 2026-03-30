# load packages
library(gt)
library(patchwork)
library(tidyverse)


# read dataset
beach <- read_rds("data/01_ttc/03_beach_clean.rds")
park <- read_rds("data/01_ttc/04_park_clean.rds")


# visualize table
beach_table <- beach |>
  head(10) |>
  gt()

gtsave(beach_table, filename = "graphs/01_ttc/00_beach/00_table.png")

park_table <- park |>
  head(10) |>
  gt()

gtsave(park_table, filename = "graphs/01_ttc/01_park/00_table.png")


# visualize time series
beach_time <- beach |>
  mutate(month = floor_date(date, "month")) |>
  group_by(month) |>
  summarise(n = n()) |>
  ggplot(aes(x = month, y = n)) +
  geom_line(color = "purple", alpha = 0.7) +
  geom_point(color = "purple", alpha = 0.7) +
  labs(x = "Time", y = "Number of Delays") +
  theme_minimal()

ggsave("graphs/01_ttc/00_beach/01_time.png", plot = beach_time)

park_time <- park |>
  mutate(month = floor_date(date, "month")) |>
  group_by(month) |>
  summarise(n = n()) |>
  ggplot(aes(x = month, y = n)) +
  geom_line(color = "purple", alpha = 0.7) +
  geom_point(color = "purple", alpha = 0.7) +
  labs(x = "Time", y = "Number of Delays") +
  theme_minimal()

ggsave("graphs/01_ttc/01_park/01_time.png", plot = park_time)


# visualize categories frequency
beach_hour <- beach |>
  mutate(hour = as.numeric(sub(":.*", "", time))) |>
  group_by(hour) |>
  summarise(n = n()) |>
  ggplot(aes(x = hour, y = n, fill = -n)) +
  geom_col(width = 1, color = "white", linewidth = 0.1) +
  scale_x_continuous(
    breaks = 0:23,
    labels = 0:23
  ) +
  coord_polar(start = 0) +
  labs(x = "Time", fill = "Number of Delays") +
  scale_fill_gradient(labels = abs) +
  theme_minimal() +
  theme(
    axis.text.y = element_blank(),
    axis.title.y = element_blank()
  )

ggsave("graphs/01_ttc/00_beach/02_hour.png", plot = beach_hour)

park_hour <- park |>
  mutate(hour = as.numeric(sub(":.*", "", time))) |>
  group_by(hour) |>
  summarise(n = n()) |>
  ggplot(aes(x = hour, y = n, fill = -n)) +
  geom_col(width = 1, color = "white", linewidth = 0.1) +
  scale_x_continuous(
    breaks = 0:23,
    labels = 0:23
  ) +
  coord_polar(start = 0) +
  labs(x = "Time", fill = "Number of Delays") +
  scale_fill_gradient(labels = abs) +
  theme_minimal() +
  theme(
    axis.text.y = element_blank(),
    axis.title.y = element_blank()
  )

ggsave("graphs/01_ttc/01_park/02_hour.png", plot = park_hour)


# visualize days of the week
beach_days <- beach |>
  mutate(
    day = factor(
      day,
      levels = c(
        "Sunday", "Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday"
      )
    )
  ) |>
  count(day) |>
  ggplot(aes(x = day, y = n)) +
  geom_col(alpha = 0.7, fill = "orange") +
  labs(x = "Days of the Week", y = "Count") +
  theme_minimal()

ggsave("graphs/01_ttc/00_beach/03_days.png", plot = beach_days)

park_days <- park |>
  mutate(
    day = factor(
      day,
      levels = c(
        "Sunday", "Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday"
      )
    )
  ) |>
  count(day) |>
  ggplot(aes(x = day, y = n)) +
  geom_col(alpha = 0.7, fill = "orange") +
  labs(x = "Days of the Week", y = "Count") +
  theme_minimal()

ggsave("graphs/01_ttc/01_park/03_days.png", plot = park_days)


# visualize station frequency
beach_loc <- beach |>
  mutate(loc = fct_lump_n(loc, n = 15, other_level = "Other")) |>
  count(loc) |>
  ggplot(aes(x = reorder(loc, n), y = n)) +
  geom_col(alpha = 0.7, fill = "steelblue") +
  coord_flip() +
  labs(x = "Station", y = "Count") +
  theme_minimal()

ggsave("graphs/01_ttc/00_beach/04_station.png", plot = beach_loc)

park_loc <- park |>
  mutate(loc = fct_lump_n(loc, n = 15, other_level = "Other")) |>
  count(loc) |>
  ggplot(aes(x = reorder(loc, n), y = n)) +
  geom_col(alpha = 0.7, fill = "steelblue") +
  coord_flip() +
  labs(x = "Station", y = "Count") +
  theme_minimal()

ggsave("graphs/01_ttc/01_park/04_station.png", plot = park_loc)


# visualize incident frequency
beach_icd <- beach |>
  count(icd) |>
  ggplot(aes(x = reorder(icd, n), y = n)) +
  geom_col(alpha = 0.7, fill = "steelblue") +
  coord_flip() +
  labs(x = "Incident", y = "Count") +
  theme_minimal()

ggsave("graphs/01_ttc/00_beach/05_incident.png", plot = beach_icd)

park_icd <- park |>
  count(icd) |>
  ggplot(aes(x = reorder(icd, n), y = n)) +
  geom_col(alpha = 0.7, fill = "steelblue") +
  coord_flip() +
  labs(x = "Incident", y = "Count") +
  theme_minimal()

ggsave("graphs/01_ttc/01_park/05_incident.png", plot = park_icd)


# summary statistics of delay and gap
beach_smr <- beach |>
  select(dly, gap) |>
  pivot_longer(everything()) |>
  group_by(name) |>
  summarise(
    across(
      value, list(mean = mean, med = median, min = min, max = max, IQR = IQR)
    )
  ) |>
  gt()

gtsave(beach_smr, filename = "graphs/01_ttc/00_beach/06_summary_dg.png")

park_smr <- park |>
  select(dly, gap) |>
  pivot_longer(everything()) |>
  group_by(name) |>
  summarise(
    across(
      value, list(mean = mean, med = median, min = min, max = max, IQR = IQR)
    )
  ) |>
  gt()

gtsave(park_smr, filename = "graphs/01_ttc/01_park/06_summary_dg.png")


# visualize delay and gap distribution
beach_dly <- beach |>
  ggplot(aes(x = dly)) +
  geom_histogram(alpha = 0.7, fill = "green") +
  labs(x = "Delay", y = "Count") +
  theme_minimal()

beach_gap <- beach |>
  ggplot(aes(x = gap)) +
  geom_histogram(alpha = 0.7, fill = "green") +
  labs(x = "Gap", y = "Count") +
  theme_minimal()

beach_combined <- beach_dly / beach_gap

ggsave("graphs/01_ttc/00_beach/07_histo_dg.png", plot = beach_combined)

park_dly <- park |>
  ggplot(aes(x = dly)) +
  geom_histogram(alpha = 0.7, fill = "green") +
  labs(x = "Delay", y = "Count") +
  theme_minimal()

park_gap <- park |>
  ggplot(aes(x = gap)) +
  geom_histogram(alpha = 0.7, fill = "green") +
  labs(x = "Gap", y = "Count") +
  theme_minimal()

park_combined <- park_dly / park_gap

ggsave("graphs/01_ttc/01_park/07_histo_dg.png", plot = park_combined)
