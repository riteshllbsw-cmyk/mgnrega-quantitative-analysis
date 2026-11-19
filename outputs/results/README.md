 Query results

Run date: 2026-11-12

Each CSV contains the full result, with a header row followed by the query’s returned rows. All queries were run against a temporary copy of `mgnrega.db` using the SQL blocks in `queries.sql` without editing their statements.

## Query 1: Retrieve annual employment indicators for a selected jurisdiction and financial year.

- File: [`query_1_selected_jurisdiction_year.csv`](query_1_selected_jurisdiction_year.csv)
- Rows returned: 1
- Columns: `original_label` — jurisdiction name as stored in the database; `label` — financial year label; `hh_demanded` — households demanding employment; `hh_offered` — households offered employment; `hh_availed` — households availing employment; `persondays_total` — total persondays; `hh_completed_100_days` — families recorded as completing 100 days

## Query 2: Calculate household fulfilment and offer rates for every jurisdiction and financial year.

- File: [`query_2_fulfilment_offer_rates.csv`](query_2_fulfilment_offer_rates.csv)
- Rows returned: 352
- Columns: `original_label` — jurisdiction name as stored in the database; `label` — financial year label; `hh_demanded` — households demanding employment; `hh_offered` — households offered employment; `hh_availed` — households availing employment; `fulfilment_rate_pct` — availed households as a percentage of demanded households; `offer_rate_pct` — offered households as a percentage of demanded households

## Query 3: Identify jurisdictions with recurring household fulfilment gaps.

- File: [`query_3_recurring_fulfilment_gaps.csv`](query_3_recurring_fulfilment_gaps.csv)
- Rows returned: 13
- Columns: `original_label` — jurisdiction name as stored in the database; `eligible_years` — years with nonzero household demand; `years_below_90` — eligible years with fulfilment below 90 percent

## Query 4: Compare employment intensity and 100-day completion rates across jurisdictions and financial years.

- File: [`query_4_employment_intensity_100day.csv`](query_4_employment_intensity_100day.csv)
- Rows returned: 352
- Columns: `original_label` — jurisdiction name as stored in the database; `label` — financial year label; `persondays_total` — total persondays; `hh_availed` — households availing employment; `persondays_per_availing_household` — persondays per availing household; `completion_rate_pct` — 100-day completions as a percentage of availing households

## Query 5: Analyse annual trends and year-on-year percentage changes in household demand and employment availed across jurisdictions.

- File: [`query_5_annual_trends_yoy_changes.csv`](query_5_annual_trends_yoy_changes.csv)
- Rows returned: 352
- Columns: `original_label` — jurisdiction name as stored in the database; `label` — financial year label; `hh_demanded` — households demanding employment; `hh_availed` — households availing employment; `persondays_total` — total persondays; `previous_year_demand` — household demand in the preceding year; `demand_change_pct` — year-on-year percentage change in household demand; `availed_change_pct` — year-on-year percentage change in households availing employment

## Query 6: Compare employment outcomes across pre-pandemic, pandemic, and post-pandemic periods.

- File: [`query_6_pandemic_period_comparison.csv`](query_6_pandemic_period_comparison.csv)
- Rows returned: 3
- Columns: `period` — pre-pandemic, pandemic, or post-pandemic period; `total_demanded` — total demanded households in the period; `total_availed` — total availing households in the period; `fulfilment_rate_pct` — availed households as a percentage of demanded households; `offer_rate_pct` — offered households as a percentage of demanded households; `avg_annual_demand_availed_gap` — average annual difference between demanded and availing households; `avg_annual_persondays` — average annual total persondays

## Query 7: Flag source records with unusual relationships between households demanding, offered, and availing employment.

- File: [`query_7_unusual_source_relationships.csv`](query_7_unusual_source_relationships.csv)
- Rows returned: 9
- Columns: `original_label` — jurisdiction name as stored in the database; `label` — financial year label; `hh_demanded` — households demanding employment; `hh_offered` — households offered employment; `hh_availed` — households availing employment
