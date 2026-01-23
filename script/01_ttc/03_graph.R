# load packages
library(gt)
library(patchwork)
library(tidyverse)


# read dataset
data <- read_rds("data/01_ttc/02_clean.rds")


# visualize table
table <- data |>
  head(10) |>
  gt()

gtsave(table, filename = "graphs/01_ttc/00_table.png")


# visualize time series
time <- data |>
  mutate(month = floor_date(date, "month")) |>
  group_by(month) |>
  summarise(n = n()) |>
  ggplot(aes(x = month, y = n)) +
  geom_line(color = "purple", alpha = 0.7) +
  geom_point(color = "purple", alpha = 0.7) +
  labs(x = "Time", y = "Number of Delays") +
  theme_minimal()

ggsave("graphs/01_ttc/01_time.png", plot = time)


# visualize categories frequency
hour <- data |>
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

ggsave("graphs/01_ttc/02_hour.png", plot = hour)


# visualize days of the week
days <- data |>
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

ggsave("graphs/01_ttc/03_days.png", plot = days)


# visualize station frequency
loc <- data |>
  mutate(loc = fct_lump_n(loc, n = 15, other_level = "Other")) |>
  count(loc) |>
  ggplot(aes(x = reorder(loc, n), y = n)) +
  geom_col(alpha = 0.7, fill = "steelblue") +
  coord_flip() +
  labs(x = "Station", y = "Count") +
  theme_minimal()

ggsave("graphs/01_ttc/04_station.png", plot = loc)


# visualize incident frequency
icd <- data |>
  count(icd) |>
  ggplot(aes(x = reorder(icd, n), y = n)) +
  geom_col(alpha = 0.7, fill = "steelblue") +
  coord_flip() +
  labs(x = "Incident", y = "Count") +
  theme_minimal()

ggsave("graphs/01_ttc/05_incident.png", plot = icd)


# summary statistics of delay and gap
smr <- data |>
  select(dly, gap) |>
  pivot_longer(everything()) |>
  group_by(name) |>
  summarise(
    across(
      value, list(mean = mean, med = median, min = min, max = max, IQR = IQR)
    )
  ) |>
  gt()

gtsave(smr, filename = "graphs/01_ttc/06_summary_delay_gap.png")


# visualize delay and gap distribution
dly <- data |>
  ggplot(aes(x = gap)) +
  geom_histogram(alpha = 0.7, fill = "green") +
  labs(x = "Delay", y = "Count") +
  theme_minimal()

gap <- data |>
  ggplot(aes(x = gap)) +
  geom_histogram(alpha = 0.7, fill = "green") +
  labs(x = "Gap", y = "Count") +
  theme_minimal()

combined <- dly / gap

ggsave("graphs/01_ttc/07_histo_delay_gap.png", plot = combined)
