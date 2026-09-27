# Dataset recommendation

## Decision

Use the CDC NNDSS weekly West Nile virus disease data for the main workshop workflow.

The unit is a U.S. state–MMWR week. The classification target is whether at least one West Nile virus disease case will be reported in the following four weeks. This creates a clear prospective question while keeping all model inputs in the past.

## Why this dataset

The CDC weekly table is the strongest practical fit for this workshop because it is:

- directly connected to infectious-disease surveillance;
- available through a documented public API;
- large enough for a train/validation/test workflow;
- naturally temporal, so participants can see why validation design matters;
- small enough to run quickly during a live two-hour session;
- compatible with logistic regression, a decision tree and a random forest.

The final modelling table has 10,239 complete state-week observations for 2022–2025. The outcome is intentionally imbalanced: about 5–7% of state-weeks are positive depending on year. That makes sensitivity, specificity, thresholds and ROC AUC meaningful teaching topics.

## Candidate comparison

| Criterion | CDC West Nile weekly data | Ebola outbreak data | Heart disease data |
|---|---|---|---|
| Source | CDC NNDSS public dataset | WHO outbreak materials and heterogeneous outbreak releases | OpenML/UCI; used by Wright et al. (2026) |
| Reproducible access | Direct CSV/API query plus frozen snapshot | No single stable, analysis-ready table identified for the intended task | Straightforward download |
| Observations | State × MMWR week | Depends on outbreak and release | Patient |
| Classification outcome | Any reported case in the next four weeks | Would require a defensible outbreak-specific definition | Heart disease present/absent |
| Sample size | More than 10,000 modelling rows | Variable; often small or aggregated | 270 rows in the Statlog version |
| Temporal structure | Strong and explicit | Strong but outbreak-specific | None |
| Class balance | Imbalanced; useful for evaluation teaching | Uncertain until a specific release is fixed | Roughly balanced |
| Leakage risk | Manageable with lagged features and time-based splits | High if outbreak summaries or future totals are used | Manageable with ordinary resampling |
| Epidemiological fit | Excellent and aligned with infectious-disease work | Excellent subject matter, weaker live-workshop reliability | Good general clinical example, weaker connection to infectious disease |
| Live reliability | High with the frozen snapshot | Lower | Very high |
| Decision | **Selected** | Not selected | Retained as a fallback |

## Exact task definition

- **Population:** the 50 U.S. states and the District of Columbia.
- **Time unit:** MMWR week.
- **Geographic handling:** New York State and New York City rows are combined into one New York total.
- **Target:** `activity_next_4w = yes` if the sum of reported cases in weeks `t+1` through `t+4` is greater than zero.
- **Predictors:** cases at lags 1, 2 and 4; case totals over the previous 4 and 8 weeks; number of active weeks in the previous 8 weeks; sine and cosine of MMWR week; census region.
- **Development data:** 2022–2024.
- **Temporal validation:** train on 2022/test on 2023, then train on 2022–2023/test on 2024.
- **Final holdout:** 2025, evaluated once after model and threshold choices.
- **Excluded:** partial 2026 predictors and targets, aggregate regions, territories, national totals, future variables and CDC cumulative/previous-52-week fields.

## Leakage controls

1. No same-week or future case count is used as a predictor.
2. Rolling features are calculated after shifting the case series by one week.
3. Temporal validation always trains on years earlier than the validation year.
4. The classification threshold is selected from 2023–2024 validation predictions.
5. The 2025 holdout is not used to select features, models or thresholds.
6. The 2026 partial year supplies only labels for late-2025 rows and never enters model fitting.

## Important limits

- NNDSS weekly counts are provisional and subject to revision.
- A `-` flag means no reported cases; `U` means unavailable and is kept missing.
- Reports are assigned to reporting jurisdictions and do not necessarily identify the place of exposure.
- Under-reporting, delayed reporting and jurisdiction-specific practices affect the observed series.
- The predictors omit population, weather, mosquito surveillance and control measures.
- The model predicts reported activity. It does not explain transmission or estimate causal effects.
