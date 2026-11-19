# MGNREGA Data Validation Report

Audit date: 15 October 2026. Scope: read-only inspection of local raw files, plus limited official-source checks. No raw file, database, or analytical query was modified or created.

## A. Executive summary

- **CONFIRMED:** The workspace contains 11 annual R5.1.1 MIS reports for FY 2014-15 through FY 2024-25, a historical state/UT CSV, and a parliamentary 100-day CSV. The earlier PIB extracts are not physically present.
- **CONFIRMED:** Each MIS file is an HTML table with a misleading `.xls` extension. Each has 32 State/UT rows, one `Total` row, identical 24-column structure, no exact duplicate records, no missing numeric cells, no negative values, and totals that exactly equal the sum of displayed State/UT rows.
- **CONFIRMED:** The same 32 labels occur as both table rows and `state_name` links in every MIS file. `KERALA`, `MAHARASHTRA`, `CHANDIGARH`, and `DELHI` are absent from the local MIS HTML.
- **UNRESOLVED:** Local evidence does not explain those four absences. It does not establish zero activity, exclusion from MGNREGA, portal defect, or alternative reporting.
- **SUPPORTED BUT NOT DEFINITIVE:** The MIS is the best primary source for a consistent 32-jurisdiction annual series. It must not be represented as all-India State/UT coverage without a documented scope limitation.

## B. Actual file inventory

| Relative path | Size | Actual format | Coverage or contents |
|---|---:|---|---|
| `data/raw/mis_reports/mis_employment_generated_2014-15.xls` | 94,948 B | HTML | FY 2014-15 |
| `data/raw/mis_reports/mis_employment_generated_2015-16.xls` | 94,982 B | HTML | FY 2015-16 |
| `data/raw/mis_reports/mis_employment_generated_2016-17.xls` | 95,014 B | HTML | FY 2016-17 |
| `data/raw/mis_reports/mis_employment_generated_2017-18.xls` | 95,010 B | HTML | FY 2017-18 |
| `data/raw/mis_reports/mis_employment_generated_2018-19.xls` | 94,992 B | HTML | FY 2018-19 |
| `data/raw/mis_reports/mis_employment_generated_2019-20.xls` | 94,976 B | HTML | FY 2019-20 |
| `data/raw/mis_reports/mis_employment_generated_2020-21.xls` | 95,108 B | HTML | FY 2020-21 |
| `data/raw/mis_reports/mis_employment_generated_2021-22.xls` | 95,083 B | HTML | FY 2021-22 |
| `data/raw/mis_reports/mis_employment_generated_2022-23.xls` | 95,075 B | HTML | FY 2022-23 |
| `data/raw/mis_reports/mis_employment_generated_2023-24.xls` | 95,067 B | HTML | FY 2023-24 |
| `data/raw/mis_reports/mis_employment_generated_2024-25.xls` | 94,993 B | HTML | FY 2024-25 |
| `syb-18-chapter_35_rural_urban_development_state_table_35.1.csv` | 14,641 B | CSV | FY 2010-11 to FY 2017-18; 35 State/UT rows, 74 columns |
| `RS_Session_265_AU_622_A_i.csv` | 1,886 B | CSV | FY 2019-20 to FY 2023-24 100-day households; 34 State/UT rows plus `Total` |

MacOS `.DS_Store` files exist but are not datasets. No PIB-derived CSV, existing `outputs/` data file, database, or other relevant CSV was found before this report was created.

## C. Jurisdiction coverage findings

### MIS evidence

- **CONFIRMED:** Every MIS report has exactly the same 32 State/UT labels and one separate `Total` row. The 32 labels are: `ANDAMAN AND NICOBAR`, `ANDHRA PRADESH`, `ARUNACHAL PRADESH`, `ASSAM`, `BIHAR`, `CHHATTISGARH`, `DN HAVELI AND DD`, `GOA`, `GUJARAT`, `HARYANA`, `HIMACHAL PRADESH`, `JAMMU AND KASHMIR`, `JHARKHAND`, `KARNATAKA`, `LADAKH`, `LAKSHADWEEP`, `MADHYA PRADESH`, `MANIPUR`, `MEGHALAYA`, `MIZORAM`, `NAGALAND`, `ODISHA`, `PUDUCHERRY`, `PUNJAB`, `RAJASTHAN`, `SIKKIM`, `TAMIL NADU`, `TELANGANA`, `TRIPURA`, `UTTAR PRADESH`, `UTTARAKHAND`, and `WEST BENGAL`.
- **CONFIRMED:** In each local HTML file, the 32 row labels exactly match the 32 `demregister.aspx?...page=S...&source=national` state-link parameters. Example evidence: `data/raw/mis_reports/mis_employment_generated_2019-20.xls` contains `fin_year=2019-2020`, `state_code`, `state_name`, `source=national`, and a `Digest` parameter for each listed jurisdiction.
- **CONFIRMED:** The four labels `KERALA`, `MAHARASHTRA`, `CHANDIGARH`, and `DELHI` occur neither as state rows nor as state-specific links in any of the 11 local MIS files.
- **UNRESOLVED:** No local title, form action, timestamp, footnote, exclusion note, or source identifier explains the scope. Official web searches performed for R5.1.1 documentation did not yield an authoritative explanation of the four missing jurisdictions. Do not infer an explanation.

### Implication

Use an explicit `included_in_mis_series` flag in future documentation. Keep the four absent jurisdictions outside MIS-derived comparisons rather than assigning zero or attempting to reconstruct them.

## D. Historical boundary findings

- **CONFIRMED:** `LADAKH` and combined `DN HAVELI AND DD` appear in all local MIS files, including FY 2014-15.
- **CONFIRMED:** The Ministry of Home Affairs states that the Union Territory of Ladakh came into existence on 31 October 2019. [MHA J&K and Ladakh Affairs](https://www.mha.gov.in/en/divisionofmha/jammu-kashmir-and-ladakh-affairs)
- **CONFIRMED:** MHA records the merger of Dadra and Nagar Haveli with Daman and Diu, effective 26 January 2020. [MHA order](https://www.mha.gov.in/sites/default/files/Circular_GovtofNCTofDelhi_29012020_0.PDF)
- **SUPPORTED BUT NOT DEFINITIVE:** Because the post-change labels occur for pre-change years, the portal may be retrospectively presenting historical figures under current labels. The local files alone cannot establish whether the values were merged, split, reassigned, or otherwise reclassified.
- **Recommended mapping strategy:** preserve the raw jurisdiction label and financial year unchanged; create a future geographic crosswalk with `raw_label`, `analysis_geography`, `valid_from`, `valid_to`, and `mapping_basis`. Do not merge/split values without source evidence. Exclude pre-2019 `LADAKH` and pre-2020 combined `DN HAVELI AND DD` from strict historical-boundary comparisons unless the portal convention is documented.

## E. Report metadata and finality

- **CONFIRMED:** Each HTML file identifies the report as `R5.1.1 Employment Generated during the year` and contains the selected financial-year option matching its filename.
- **CONFIRMED:** The local files contain no visible generation timestamp, `as of` date, provisional/final/revised status, full source URL, or revision policy.
- **SUPPORTED BUT NOT DEFINITIVE:** The Ministry of Rural Development's Annual Master Circular describes NREGAsoft MIS reports, confirming an official MIS reporting context, but the checked material does not establish that these extracts are immutable final annual figures. [Annual Master Circular 2020-21](https://rural.gov.in/sites/default/files/MGNREGA_Guidelines_English.pdf)
- **UNRESOLVED:** Historical revision behaviour for R5.1.1. Treat the downloaded files as dated snapshots, not definitively final values.

## F. Indicator definitions and comparability

### MIS table labels

The 24-column hierarchical MIS table consistently includes:

- `Employment demanded` — `Household`, `Persons`
- `Employment offered` — `Household`, `Persons`
- `Employment Availed` — `Household`, `Persons`, `Total Persondays`, `Persondays of Central Liability`, `Persondays of States Liability`
- `No. of Families Completed 100 days`

All local MIS values are integer strings and the report does not state lakh/crore units; use them as displayed raw counts. `Cumulative No. of HH issued jobcards` is explicitly cumulative and is not an annual outcome measure.

### Historical CSV labels

`syb-18-chapter_35_rural_urban_development_state_table_35.1.csv` uses year-specific fields including:

- `No.of households who have demanded employment - YYYY-YY`
- `No.of households provided employment - YYYY-YY`
- `Persondays (In Lakhs) - Total - YYYY-YY`
- `Average Persondays per Household - YYYY-YY`
- `Number of Households Availed 100 days of Employment - YYYY-YY`

### Comparability assessment

| Pair | Status | Reason |
|---|---|---|
| MIS demanded household vs historical demanded household | SUPPORTED BUT NOT DEFINITIVE | Similar wording; verify definitions and reference date before pooling. |
| MIS offered household vs historical provided household | UNRESOLVED | `offered` is not necessarily `provided`; do not substitute. |
| MIS availed household vs historical provided household | NOT COMPARABLE | Different terms. |
| MIS total persondays vs historical total persondays | SUPPORTED BUT NOT DEFINITIVE | Both label total persondays; historical values are explicitly in lakhs and rounded. |
| MIS families completed 100 days vs historical households availed 100 days | UNRESOLVED | Similar policy outcome, but family/household terminology has not been verified as equivalent. |
| MIS average persondays/household | NOT AVAILABLE | No corresponding MIS field. Use the historical field only for its own period unless a verified denominator/calculation is documented. |

## G. Cross-validation results

### MIS vs parliamentary 100-day CSV

The parliamentary CSV field is `Number of households completed 100 days of wage employment - YYYY-YY`; the MIS field is `No. of Families Completed 100 days`. The measures are not proven equivalent, so these are validation signals, not interchangeable values.

| FY | Comparable jurisdiction labels | Exact | Different | MIS national total | Parliamentary national total |
|---|---:|---:|---:|---:|---:|
| 2019-20 | 30 | 26 | 4 | 3,683,735 | 4,059,431 |
| 2020-21 | 30 | 24 | 6 | 6,585,838 | 7,193,603 |
| 2021-22 | 30 | 23 | 7 | 5,226,983 | 5,914,232 |
| 2022-23 | 30 | 12 | 18 | 3,004,915 | 3,596,742 |
| 2023-24 | 30 | 11 | 19 | 3,640,206 | 4,499,343 |

- **CONFIRMED:** Comparable jurisdiction-level values often match exactly, but discrepancies exist and become more frequent after 2021-22. Examples: Andhra Pradesh differs by -215 in 2019-20 and -271 in 2020-21; Chhattisgarh differs by -164 in 2022-23.
- **CONFIRMED:** National totals should not be compared as though they cover the same geography: the parliamentary file includes Kerala and Maharashtra, while the MIS does not; label differences also prevent direct matching for Andaman and Nicobar and the combined Dadra/Daman territory.

### MIS vs historical CSV

Comparison was limited to 28 matching jurisdiction labels after case/punctuation normalization. It excludes unmatched/ambiguous jurisdictions; it does not map combined `DN HAVELI AND DD` to the two historical territories.

| FY | 100-day values: exact / compared | Persondays: exact / compared |
|---|---:|---:|
| 2014-15 | 11 / 28 | 0 / 28 |
| 2015-16 | 13 / 28 | 0 / 28 |
| 2016-17 | 9 / 28 | 0 / 28 |
| 2017-18 | 1 / 28 | 0 / 28 |

- **CONFIRMED:** None of the 28 personday comparisons match exactly after converting the historical lakh values to persondays. This is expected in part because the historical source reports whole lakh values, but timing, revisions, geography, and definition differences remain unverified.
- **CONFIRMED:** The 100-day fields produce both exact matches and discrepancies; therefore neither source should overwrite the other.
- **UNRESOLVED:** The historical CSV has no national-total row, so national total cross-validation against MIS cannot be performed from that file.

## H. Recommended analytical coverage

1. **Primary series:** MIS FY 2014-15 to FY 2024-25 for its displayed 32 jurisdictions, using demanded household, offered household, availed household, total persondays, and families completing 100 days.
2. **Demand fulfilment:** analyse `demanded` versus `offered`; label the measure accurately as offers, not employment actually provided.
3. **Employment outcomes:** use MIS availed households and total persondays. Use historical average persondays per household only as a separate 2010-11 to 2017-18 supplementary series.
4. **Pandemic test:** use MIS total persondays for pre-pandemic FY 2014-15 to 2019-20, pandemic FY 2020-21 and 2021-22, and post-pandemic FY 2022-23 to 2024-25. Explain the period rule in project documentation.
5. **Validation sources:** retain the historical CSV and parliamentary CSV as audit/cross-validation sources, not automatic replacements.

## I. Confirmed issues versus unresolved questions

### Confirmed

- 32-jurisdiction MIS scope is consistent across all 11 reports.
- Four named jurisdictions are absent locally in every MIS report.
- Ladakh and combined DN Haveli/DD labels appear before their official reorganisation dates.
- MIS and parliamentary/historical series are not uniformly identical in overlaps.

### Unresolved

- Official explanation for Kerala, Maharashtra, Chandigarh, and Delhi being absent from R5.1.1 extracts.
- How NREGAsoft assigns historical values to Ladakh and combined DN Haveli/DD labels.
- Whether R5.1.1 historical values can be revised.
- Whether `families completed 100 days` and `households availed/completed 100 days` are formally equivalent.
- Exact definitions/timing behind observed cross-source discrepancies.

### Not tested

- A fresh authenticated/interactive portal export for an absent jurisdiction. The local files alone cannot substitute for that test.

## J. Prioritised next steps before database design

1. Obtain official clarification or a reproducible portal export documenting the four missing jurisdictions and historical reclassification convention.
2. Decide and document a fixed 32-jurisdiction analytical universe; do not fabricate missing State/UT data.
3. Document indicator semantics, especially `offered` vs `provided` and `families` vs `households` completing 100 days.
4. Record source snapshot dates and preserve original file hashes in project documentation.
5. Build a transparent, versioned geographic crosswalk only after the above evidence is obtained.


