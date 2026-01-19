# load packages
library(ggwordcloud)
library(gt)
library(kableExtra)
library(knitr)
library(patchwork)
library(sf)
library(tidytext)
library(tidyverse)


# read dataset
data_loc <- read_rds("data/00_event/03_event_clean.rds")
area <- read_rds("data/00_event/01_area.rds")
data <- data_loc |> st_drop_geometry()


# visualize table
table <- data |>
  distinct(categ, .keep_all = TRUE) |>
  mutate(
    categ = map_chr(categ, ~ paste(.x, collapse = ", ")),
    feat = map_chr(feat, ~ paste(.x, collapse = ", "))
  ) |>
  mutate(across(where(is.character), ~ str_sub(., 1, 15))) |>
  head(10) |>
  gt()

gtsave(table, filename = "graphs/00_event/00_table.png")


# visualize time series
time <- data |>
  count(dat) |>
  ggplot(aes(x = dat, y = n)) +
  geom_line(color = "purple", alpha = 0.7) +
  geom_point(color = "purple", alpha = 0.7) +
  labs(x = "Date", y = "Number of Events") +
  theme_minimal()

ggsave("graphs/00_event/01_time.png", plot = time)


# visualize map
map <- data_loc |>
  count(loc) |>
  ggplot() +
  geom_sf(data = area, fill = "lightblue", alpha = 0.5) +
  geom_sf(aes(geometry = loc, size = n),
          color = "red", alpha = 0.7, show.legend = FALSE) +
  scale_size_continuous(range = c(1, 6)) +
  theme_void()

ggsave("graphs/00_event/02_map.png", plot = map)


# visualize categories frequency
categ <- data |>
  unnest(categ) |>
  count(categ) |>
  ggplot(aes(x = reorder(categ, n), y = n)) +
  geom_col(alpha = 0.7, fill = "steelblue") +
  coord_flip() +
  labs(x = "Category", y = "Count") +
  theme_minimal()

ggsave("graphs/00_event/03_category.png", plot = categ)


# visualize word cloud
word_freq <- data |>
  unnest_tokens(word, descript) |>
  count(word, sort = TRUE) |>
  anti_join(stop_words) |>
  head(30)

word <- ggplot(word_freq, aes(label = word, size = n, color = n)) +
  geom_text_wordcloud() +
  scale_size_area(max_size = 15) +
  scale_color_gradient(low = "orange", high = "darkblue") +
  theme_minimal()

ggsave("graphs/00_event/04_word_cloud.png", plot = word)


# visualize free and reservation proportion
free <- data |>
  count(free) |>
  mutate(percentage = n / sum(n) * 100) |>
  ggplot(aes(x = "", y = n, fill = free)) +
  geom_bar(stat = "identity", width = 1) +
  scale_fill_manual(values = c("darkgreen", "firebrick")) +
  geom_text(aes(label = paste0(round(percentage, 2), "%")), 
            position = position_stack(vjust = 0.5)) +
  coord_polar("y", start = 0) +
  theme_void()

reserv <- data |>
  count(reserv) |>
  mutate(percentage = n / sum(n) * 100) |>
  ggplot(aes(x = "", y = n, fill = reserv)) +
  geom_bar(stat = "identity", width = 1) +
  scale_fill_manual(values = c("darkgreen", "firebrick")) +
  geom_text(aes(label = paste0(round(percentage, 2), "%")), 
            position = position_stack(vjust = 0.5)) +
  coord_polar("y", start = 0) +
  theme_void()

combined <- free + reserv
ggsave("graphs/00_event/05_free_reservation.png", plot = combined)


# visualize features frequency
feat <- data |>
  unnest(feat) |>
  count(feat) |>
  ggplot(aes(x = reorder(feat, n), y = n)) +
  geom_col(alpha = 0.7, fill = "steelblue") +
  coord_flip() +
  labs(x = "Feature", y = "Count") +
  theme_minimal()

ggsave("graphs/00_event/06_feature.png", plot = feat)
