if (!exists("wnv_model_data")) source("R/01-data.R")

annual_balance <- wnv_model_data[
  , .(
    observations = .N,
    positive = sum(activity_next_4w == "yes"),
    positive_share = mean(activity_next_4w == "yes")
  ),
  by = year
]

p_balance <- ggplot(
  annual_balance,
  aes(x = factor(year), y = positive_share)
) +
  geom_col(fill = "#6A3D9A", width = 0.7) +
  geom_text(
    aes(label = scales::percent(positive_share, accuracy = 0.1)),
    vjust = -0.4,
    size = 3.6
  ) +
  scale_y_continuous(labels = scales::percent, limits = c(0, 0.10)) +
  labs(
    title = "West Nile activity is an imbalanced prediction outcome",
    subtitle = "Positive means at least one reported case in the following four weeks",
    x = "MMWR year",
    y = "Positive state-weeks"
  ) +
  workshop_theme()

ggsave("figures/01-class-balance.png", p_balance, width = 8, height = 5, dpi = 160)

weekly_cases <- wnv_panel[year %between% c(2022L, 2025L), .(
  reported_cases = sum(cases, na.rm = TRUE)
), by = .(year, week)]

p_season <- ggplot(weekly_cases, aes(week, reported_cases, colour = factor(year))) +
  geom_line(linewidth = 0.8) +
  scale_colour_brewer(palette = "Dark2") +
  labs(
    title = "Reported West Nile cases follow a strong seasonal pattern",
    subtitle = "Weekly total across the 50 states and District of Columbia",
    x = "MMWR week",
    y = "Reported cases",
    colour = "Year"
  ) +
  workshop_theme()

ggsave("figures/02-seasonality.png", p_season, width = 9, height = 5, dpi = 160)

message("Exploration figures saved in figures/.")
