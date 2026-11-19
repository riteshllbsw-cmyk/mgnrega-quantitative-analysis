# Project Status: MGNREGA Employment Data Analysis

Last reviewed: 18 November 2026.

## 1. Project purpose and research objectives

This CS50 SQL project analyzes recorded MGNREGA employment outcomes using SQLite and SQL while preserving the original government source files.

## 2. Final working title

**From Legal Guarantee to Recorded Delivery: Measuring the MGNREGA Demand Gap Across States, 2014–15 to 2024–25**

## 3. Final research questions

### RQ1 — Employment demand fulfilment

How did households availing employment compare with registered household employment demand across displayed jurisdictions between FY 2014-15 and FY 2024-25, and which jurisdictions repeatedly recorded gaps?

- Primary measure: `households availing employment / households demanding employment * 100`.
- Secondary measure: `households offered employment / households demanding employment * 100`.
- The broad research question considers the magnitude and frequency of recorded gaps. Query 3 adds a separate descriptive screen: fulfilment below 90% in at least six eligible years, where eligible years have nonzero household demand. This operational rule identifies repeated recorded shortfalls. The project files do not document why those exact cutoffs were selected; they are analytical conventions, not statutory thresholds or causal criteria.

### RQ2 — Employment outcomes

How did total persondays and households/families completing 100 days vary across displayed jurisdictions and over time?

Potential derived measures, only after definition checks:

- Persondays per household availing employment.
- Households/families completing 100 days as a share of households availing employment.

### RQ3 — Pandemic stress test

How did persondays and the gap between employment demand and employment availed change during FY 2020-21 and FY 2021-22, relative to the pre-pandemic and post-pandemic periods?

- Pre-pandemic: FY 2014-15 through FY 2019-20.
- Pandemic: FY 2020-21 and FY 2021-22.
- Post-pandemic: FY 2022-23 through FY 2024-25.

These are descriptive questions and must not be used for causal claims.

## 4. Source datasets and locations

### Primary MIS series

`data/raw/mis_reports/` contains 11 files from FY 2014-15 through FY 2024-25:

- `mis_employment_generated_2014-15.xls`
- `mis_employment_generated_2015-16.xls`
- `mis_employment_generated_2016-17.xls`
- `mis_employment_generated_2017-18.xls`
- `mis_employment_generated_2018-19.xls`
- `mis_employment_generated_2019-20.xls`
- `mis_employment_generated_2020-21.xls`
- `mis_employment_generated_2021-22.xls`
- `mis_employment_generated_2022-23.xls`
- `mis_employment_generated_2023-24.xls`
- `mis_employment_generated_2024-25.xls`

Despite their `.xls` suffixes, all 11 are HTML tables. Do not overwrite, convert, or edit them.

Selected source-table columns use zero-based positions:

- `1`: State/jurisdiction label
- `12`: Employment demanded — Household
- `14`: Employment offered — Household
- `16`: Employment Availed — Household
- `18`: Total Persondays
- `21`: No. of Families Completed 100 days

The final `Total` row is a national aggregate and must not be loaded as a jurisdiction observation.

### Supplementary sources

- `syb-18-chapter_35_rural_urban_development_state_table_35.1.csv`: historical state/UT statistics for FY 2010-11 to FY 2017-18. It includes demand, households provided employment, total persondays in lakhs, average persondays per household, and households availing 100 days. It has definition, geography, timing, and rounding limitations.
- `RS_Session_265_AU_622_A_i.csv`: parliamentary state/UT CSV for households completing 100 days for FY 2019-20 to FY 2023-24.
- `outputs/mgnrega_data_validation_report.md`: detailed data-validation audit completed on 15 October 2026.

No PIB-derived CSV file is physically present in this project.

## 5. Data validation already performed

The validation report established the following from the local MIS HTML files:

- Each report has the same 24-column, three-row hierarchical table structure.
- Each report has 32 jurisdiction rows and one `Total` row.
- The same 32 labels occur as visible rows and as state-specific HTML links in every report.
- No exact duplicate rows, blank selected-indicator cells, malformed selected values, or negative selected values were found.
- The `Total` row reconciles exactly with the sum of the displayed 32 jurisdictions for each numeric field in each report.
- `KERALA`, `MAHARASHTRA`, `CHANDIGARH`, and `DELHI` are absent from every local MIS report. The cause is unresolved. Their absence is not zero employment or proof of a defective report.
- `LADAKH` and combined `DN HAVELI AND DD` appear before the relevant official administrative changes. The report convention for historical geography is unresolved.
- The MIS 100-day series has some exact matches and some discrepancies against the parliamentary CSV. The historical CSV's persondays values are in rounded lakhs and do not exactly match raw MIS counts.

Read `outputs/mgnrega_data_validation_report.md` before making any geographic mapping or combining sources.

## 6. Database schema and design decisions

`schema.sql` defines three tables:

```text
financial_years(fin_year_id, label, start_year)
jurisdictions(jurisdiction_id, original_label, jurisdiction_type, analysis_unit)
mis_annual_indicators(
  jurisdiction_id, fin_year_id, hh_demanded, hh_offered,
  hh_availed, persondays_total, hh_completed_100_days
)
```

Design choices already implemented:

- `financial_years.label` and `start_year` are unique.
- `jurisdictions.original_label` is unique; raw labels are preserved.
- `jurisdiction_type` is constrained to `State` or `UT`.
- `mis_annual_indicators` has composite primary key `(jurisdiction_id, fin_year_id)`.
- Indicator columns have non-negative checks.
- `mis_annual_indicators` declares foreign keys to both lookup tables.

Important SQLite note: foreign-key clauses are present in the schema, but SQLite enforces foreign keys per connection. The audit's read-only SQLite connection reported `PRAGMA foreign_keys = 0`. Every future interactive SQLite session or import transaction must execute `PRAGMA foreign_keys = ON;` before writing data.

## 7. Current database contents and record counts

Read-only inspection on 18 November 2026 found two database files:

| Database | Table | Rows | Notes |
|---|---|---:|---|
| `mgnrega.db` | `financial_years` | 11 | FY 2014-15 through FY 2024-25 |
| `mgnrega.db` | `jurisdictions` | 32 | 26 States and 6 UTs |
| `mgnrega.db` | `mis_annual_indicators` | 352 | 32 jurisdictions by 11 financial years |
| `mgnrega.db` | `staging_raw` | 34 | Separate annual-report staging table |
| `mgnrega_rebuild.db` | `financial_years` | 11 | Rebuilt from the consolidated CSV |
| `mgnrega_rebuild.db` | `jurisdictions` | 32 | Rebuilt reference rows |
| `mgnrega_rebuild.db` | `mis_annual_indicators` | 352 | Rebuilt indicator observations |

The rebuilt database contains only the three permanent tables defined by `schema.sql`; its temporary consolidated staging table was dropped after loading. Read-only `PRAGMA foreign_key_check` returned no rows for either database.

## 8. SQL work completed

- `schema.sql` defines the three permanent tables described above.
- `seed.sql` inserts the 11 financial years and 32 jurisdictions, then loads indicator records from the consolidated CSV staging table by joining source labels to reference-table labels.
- `staging.sql` remains the separate 24-column staging definition for annual MIS report imports; it is not part of the consolidated rebuild.
- `queries.sql` contains seven analytical SELECT queries. Saved results are in `outputs/results/`.
- `mgnrega_rebuild.db` was built from the consolidated CSV with 352 indicator records and three permanent tables. The rebuild used foreign-key enforcement; a read-only foreign-key check returned no violations.
- `DESIGN.md` exists but is empty.

## 9. Python-based experimentation that was abandoned

`import_data.py` was audited and removed on 19 October 2026.

It imported `sqlite3`, `pathlib`, and `pandas`; declared years and the 32-jurisdiction classification; enabled foreign keys; and inserted jurisdiction rows. It did **not** parse the HTML MIS reports, insert financial years, or insert annual indicator observations.

The database's jurisdiction rows are consistent with the script's mapping, but the script itself is not evidence that it ran. There are no other Python files, Python bytecode files, virtual-environment files, requirements files, or clearly generated Python import artifacts in the project.

## 10. Cleanup performed

Deleted:

- `import_data.py` — removed because it was an abandoned Python/pandas import experiment and the project will use a non-Python, explainable import workflow.

Preserved at the time of the 19 October 2026 cleanup:

- All raw MIS HTML-in-`.xls` reports.
- Both supplementary CSVs.
- `mgnrega.db`, `schema.sql`, `queries.sql`, `DESIGN.md`, and the validation report.
- `mgnrega.sb`, an empty file with uncertain purpose, was then reported as retained. It is absent from the current project tree; its later disposition is not verified here.

## 11. Data-loading workflows

The consolidated CSV workflow is implemented. `cs50-data-export/mgnrega_annual_indicators.csv` is imported into a seven-column TEMP table in the sqlite3 shell. Running `seed.sql` populates the reference tables, inserts indicator rows using label joins, and drops the TEMP table after loading. The rebuild steps are documented in the root `README.md`.

The original annual-report workflow remains separate. The `.xls` files are HTML tables, and the existing `staging.sql` plus `import_instruction.md` describe the report-shaped `staging_raw` import. That workflow is not required to rebuild the consolidated three-table database.

## 12. Query 3 screening convention

Query 3 defines a recurring gap as fulfilment below 90% in at least six eligible years; years with zero household demand are excluded. The 90% cutoff and six-year count provide a consistent descriptive screen for repeated recorded shortfalls. The project files do not document why those exact values were chosen. They are analytical conventions, not statutory standards or causal criteria.

## 13. Known limitations and unresolved questions

- The MIS series is a consistent 32-jurisdiction series, not proven complete all-India State/UT coverage.
- Reasons for the absence of Kerala, Maharashtra, Chandigarh, and Delhi are unresolved.
- Historical treatment of Ladakh and combined DN Haveli/DD labels is unresolved; do not merge, split, or reassign values without evidence.
- The local reports show no `as of`, final, provisional, or revision status. Treat them as downloaded snapshots, not definitively immutable final figures.
- `Employment offered` must not be relabelled as `provided` without a definition check.
- `Families Completed 100 days` must not be assumed equal to historical `Households Availed 100 days` solely on wording.
- Supplementary datasets must not overwrite primary MIS observations.

## Current documentation status

The consolidated CSV database rebuild and seven analytical queries are implemented, and saved query outputs are present. The root `README.md` describes the study, scope, workflow, queries, and saved findings. `DESIGN.md` remains empty.
