if (!exists("wnv_model_data")) source("advanced/R/01-data.R")

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

# Use the last 2025 cumulative YTD count for a descriptive state map. This is
# preferable to summing the weekly publication field, which is not an annual
# incidence measure. The map is descriptive and does not enter the ML models.
last_week_2025 <- wnv_jurisdictions[year == 2025L, max(as.integer(week))]
state_cases_2025 <- copy(
  wnv_jurisdictions[year == 2025L & as.integer(week) == last_week_2025]
)
state_cases_2025[, cumulative_cases := flagged_case_count(m3, m3_flag)]
state_cases_2025[state_key == "NEW YORK CITY", state_key := "NEW YORK"]
state_cases_2025 <- state_cases_2025[
  , .(
    cumulative_cases = if (anyNA(cumulative_cases)) {
      NA_real_
    } else {
      sum(cumulative_cases)
    }
  ),
  by = .(state = state_key)
]
state_cases_2025[, map_region := tolower(state)]
setorder(state_cases_2025, state)
fwrite(state_cases_2025[, .(state, cumulative_cases)], "outputs/map-state-cases-2025.csv")

state_polygons <- as.data.table(ggplot2::map_data("state"))
map_2025 <- merge(
  state_polygons,
  state_cases_2025,
  by.x = "region",
  by.y = "map_region",
  all.x = TRUE,
  sort = FALSE
)
setorder(map_2025, order)

stopifnot(!anyNA(map_2025$cumulative_cases))

p_map <- ggplot(
  map_2025,
  aes(x = long, y = lat, group = group, fill = cumulative_cases)
) +
  geom_polygon(colour = "white", linewidth = 0.25) +
  coord_quickmap() +
  scale_fill_gradient(
    low = "#F3EAF6",
    high = "#6A3D9A",
    transform = "sqrt",
    breaks = c(0, 10, 50, 100, 200),
    name = "Reported cases"
  ) +
  labs(
    title = "Reported West Nile virus disease cases by state, 2025",
    subtitle = "Cumulative NNDSS counts at MMWR week 53",
    caption = paste(
      "Provisional surveillance counts; not population-adjusted risk.",
      "Contiguous states and District of Columbia shown."
    )
  ) +
  theme_void(base_size = 12) +
  theme(
    text = element_text(colour = "#222222"),
    plot.title.position = "plot",
    plot.title = element_text(size = 18, face = "bold"),
    plot.subtitle = element_text(size = 12, colour = "grey30"),
    plot.caption.position = "plot",
    plot.caption = element_text(colour = "grey35", hjust = 0),
    plot.background = element_rect(fill = "white", colour = NA),
    panel.background = element_rect(fill = "white", colour = NA),
    legend.background = element_rect(fill = "white", colour = NA),
    legend.title = element_text(colour = "#222222"),
    legend.text = element_text(colour = "#222222"),
    legend.position = "right"
  )

ggsave(
  "figures/07-wnv-cases-map-2025.png",
  p_map,
  width = 10,
  height = 6,
  dpi = 160,
  bg = "white"
)

message("Exploration figures, including the state map, saved in figures/.")
