# Prepare a state-week West Nile prediction dataset from the frozen CDC snapshot.
# Set REFRESH_CDC_DATA=true to replace the snapshot with the current API result.

if (!exists("workshop_packages")) source("R/00-setup.R")

raw_path <- "data/raw/cdc_nndss_wnv_weekly_2022_2026.csv"
processed_path <- "data/processed/wnv_state_week.csv"

if (identical(tolower(Sys.getenv("REFRESH_CDC_DATA")), "true")) {
  message("Refreshing the CDC snapshot...")
  download_cdc_snapshot(raw_path)
}

if (!file.exists(raw_path)) {
  message("No local snapshot found; downloading the CDC data...")
  download_cdc_snapshot(raw_path)
}

wnv_raw <- fread(raw_path, na.strings = c("", "NA"))

expected_columns <- c("states", "year", "week", "label", "m1", "m1_flag")
stopifnot(all(expected_columns %in% names(wnv_raw)))
stopifnot(uniqueN(wnv_raw$label) == 1L)
stopifnot(unique(wnv_raw$label) == "Arboviral diseases, West Nile virus disease")

wnv_raw[, state_key := toupper(states)]
reporting_areas <- c(toupper(state.name), "DISTRICT OF COLUMBIA", "NEW YORK CITY")
wnv_jurisdictions <- wnv_raw[state_key %chin% reporting_areas]

wnv_jurisdictions[, cases := flagged_case_count(m1, m1_flag)]

# CDC reports New York State and New York City separately in the weekly table.
# Combine them to obtain one New York total. If either component is unavailable,
# keep the combined value missing rather than treating missing reporting as zero.
wnv_jurisdictions[state_key == "NEW YORK CITY", state_key := "NEW YORK"]

wnv_panel <- wnv_jurisdictions[
  , .(cases = if (anyNA(cases)) NA_real_ else sum(cases)),
  by = .(state = state_key, year = as.integer(year), week = as.integer(week))
]

stopifnot(wnv_panel[, uniqueN(state)] == 51L)
stopifnot(wnv_panel[, .N, by = .(state, year, week)][N > 1L, .N] == 0L)

wnv_panel <- merge(wnv_panel, state_region_lookup(), by = "state", all.x = TRUE)
stopifnot(!anyNA(wnv_panel$region))
setorder(wnv_panel, state, year, week)

# Features use information available at the end of the current week. The target
# looks forward: any reported case during the next four MMWR weeks.
wnv_panel[, `:=`(
  cases_lag1 = shift(cases, 1L),
  cases_lag2 = shift(cases, 2L),
  cases_lag4 = shift(cases, 4L),
  cases_last4 = frollsum(shift(cases, 1L), 4L, align = "right"),
  cases_last8 = frollsum(shift(cases, 1L), 8L, align = "right"),
  active_weeks_last8 = frollsum(shift(cases > 0, 1L), 8L, align = "right"),
  future_cases_4 = shift(cases, -1L) + shift(cases, -2L) +
    shift(cases, -3L) + shift(cases, -4L)
), by = state]

wnv_panel[, `:=`(
  week_sin = sin(2 * pi * week / 52.1775),
  week_cos = cos(2 * pi * week / 52.1775),
  activity_next_4w = factor(
    fifelse(future_cases_4 > 0, "yes", "no"),
    levels = c("no", "yes")
  )
)]

feature_columns <- c(
  "cases_lag1", "cases_lag2", "cases_lag4", "cases_last4",
  "cases_last8", "active_weeks_last8", "week_sin", "week_cos", "region"
)

# 2026 is partial and is used only to supply early-2026 outcomes for the final
# weeks of 2025. It is not part of model training or evaluation.
wnv_model_data <- wnv_panel[
  year %between% c(2022L, 2025L) &
    complete.cases(wnv_panel[, c("activity_next_4w", feature_columns), with = FALSE])
]
wnv_model_data[, row_id := .I]
setcolorder(wnv_model_data, c("row_id", "state", "region", "year", "week"))

stopifnot(all(wnv_model_data$year %in% 2022:2025))
stopifnot(all(levels(wnv_model_data$activity_next_4w) == c("no", "yes")))
stopifnot(wnv_model_data[year == 2025L, .N] > 2500L)

fwrite(wnv_model_data, processed_path)

data_quality_summary <- wnv_model_data[
  , .(
    observations = .N,
    states = uniqueN(state),
    positive_outcomes = sum(activity_next_4w == "yes"),
    positive_share = mean(activity_next_4w == "yes"),
    reported_cases = sum(cases, na.rm = TRUE),
    unavailable_current_week = sum(is.na(cases))
  ),
  by = year
]
fwrite(data_quality_summary, "outputs/data-quality-summary.csv")

message("Prepared ", nrow(wnv_model_data), " state-week observations.")
print(data_quality_summary)
