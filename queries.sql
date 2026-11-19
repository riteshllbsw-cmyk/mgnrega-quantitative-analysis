-- Query 1: Retrieve annual employment indicators for a selected jurisdiction and financial year.

SELECT
    j.original_label,
    fy.label,
    m.hh_demanded,
    m.hh_offered,
    m.hh_availed,
    m.persondays_total,
    m.hh_completed_100_days
FROM mis_annual_indicators AS m
JOIN jurisdictions AS j
    ON m.jurisdiction_id = j.jurisdiction_id
JOIN financial_years AS fy
    ON m.fin_year_id = fy.fin_year_id
WHERE j.original_label = 'BIHAR'
  AND fy.label = '2020-21';

  -- Query 2: Calculate household fulfilment and offer rates
-- for every jurisdiction and financial year.

SELECT
    j.original_label,
    fy.label,
    m.hh_demanded,
    m.hh_offered,
    m.hh_availed,
    ROUND(
        100.0 * m.hh_availed / NULLIF(m.hh_demanded, 0),
        2
    ) AS fulfilment_rate_pct,
    ROUND(
        100.0 * m.hh_offered / NULLIF(m.hh_demanded, 0),
        2
    ) AS offer_rate_pct
FROM mis_annual_indicators AS m
JOIN jurisdictions AS j
    ON m.jurisdiction_id = j.jurisdiction_id
JOIN financial_years AS fy
    ON m.fin_year_id = fy.fin_year_id;

    -- Query 3: Identify jurisdictions with recurring household fulfilment gaps.
-- A recurring gap is defined as a fulfilment rate below 90% in at least
-- six eligible years. The 90% threshold is an analytical convention,
-- not a statutory benchmark. Years with zero demand are excluded.

SELECT
    j.original_label,
    COUNT(
        CASE
            WHEN m.hh_demanded > 0 THEN 1
        END
    ) AS eligible_years,
    COUNT(
        CASE
            WHEN m.hh_demanded > 0
             AND 100.0 * m.hh_availed / m.hh_demanded < 90
            THEN 1
        END
    ) AS years_below_90
FROM mis_annual_indicators AS m
JOIN jurisdictions AS j
    ON m.jurisdiction_id = j.jurisdiction_id
JOIN financial_years AS fy
    ON m.fin_year_id = fy.fin_year_id
GROUP BY j.original_label
HAVING COUNT(
    CASE
        WHEN m.hh_demanded > 0
         AND 100.0 * m.hh_availed / m.hh_demanded < 90
        THEN 1
    END
) >= 6;

-- Query 4: Compare employment intensity and 100-day completion rates
-- across jurisdictions and financial years.

SELECT
    j.original_label,
    fy.label,
    m.persondays_total,
    m.hh_availed,
    ROUND(
        1.0 * m.persondays_total / NULLIF(m.hh_availed, 0),
        2
    ) AS persondays_per_availing_household,
    ROUND(
        100.0 * m.hh_completed_100_days / NULLIF(m.hh_availed, 0),
        2
    ) AS completion_rate_pct
FROM mis_annual_indicators AS m
JOIN jurisdictions AS j
    ON m.jurisdiction_id = j.jurisdiction_id
JOIN financial_years AS fy
    ON m.fin_year_id = fy.fin_year_id;

    -- Query 5: Analyse annual trends and year-on-year percentage changes
-- in household demand and employment availed across jurisdictions.

SELECT
    j.original_label,
    fy.label,
    m.hh_demanded,
    m.hh_availed,
    m.persondays_total,
    LAG(m.hh_demanded) OVER (
        PARTITION BY j.jurisdiction_id
        ORDER BY fy.start_year
    ) AS previous_year_demand,
    ROUND(
        100.0 * (
            m.hh_demanded - LAG(m.hh_demanded) OVER (
                PARTITION BY j.jurisdiction_id
                ORDER BY fy.start_year
            )
        ) / NULLIF(
            LAG(m.hh_demanded) OVER (
                PARTITION BY j.jurisdiction_id
                ORDER BY fy.start_year
            ),
            0
        ),
        2
    ) AS demand_change_pct,
    ROUND(
        100.0 * (
            m.hh_availed - LAG(m.hh_availed) OVER (
                PARTITION BY j.jurisdiction_id
                ORDER BY fy.start_year
            )
        ) / NULLIF(
            LAG(m.hh_availed) OVER (
                PARTITION BY j.jurisdiction_id
                ORDER BY fy.start_year
            ),
            0
        ),
        2
    ) AS availed_change_pct
FROM mis_annual_indicators AS m
JOIN jurisdictions AS j
    ON m.jurisdiction_id = j.jurisdiction_id
JOIN financial_years AS fy
    ON m.fin_year_id = fy.fin_year_id
ORDER BY j.original_label, fy.start_year;

-- Query 6: Compare employment outcomes across pre-pandemic,
-- pandemic, and post-pandemic periods.
-- Rates use pooled period totals; persondays and the demand–availed
-- gap are expressed as average annual figures.

SELECT
    CASE
        WHEN fy.start_year <= 2019 THEN 'Pre-pandemic'
        WHEN fy.start_year BETWEEN 2020 AND 2021 THEN 'Pandemic'
        ELSE 'Post-pandemic'
    END AS period,
    SUM(m.hh_demanded) AS total_demanded,
    SUM(m.hh_availed) AS total_availed,
    ROUND(
        100.0 * SUM(m.hh_availed)
        / NULLIF(SUM(m.hh_demanded), 0),
        2
    ) AS fulfilment_rate_pct,
    ROUND(
        100.0 * SUM(m.hh_offered)
        / NULLIF(SUM(m.hh_demanded), 0),
        2
    ) AS offer_rate_pct,
    1.0 * SUM(m.hh_demanded - m.hh_availed)
        / COUNT(DISTINCT fy.start_year)
        AS avg_annual_demand_availed_gap,
    1.0 * SUM(m.persondays_total)
        / COUNT(DISTINCT fy.start_year)
        AS avg_annual_persondays
FROM mis_annual_indicators AS m
JOIN jurisdictions AS j
    ON m.jurisdiction_id = j.jurisdiction_id
JOIN financial_years AS fy
    ON m.fin_year_id = fy.fin_year_id
GROUP BY period;

-- Query 7: Flag source records with unusual relationships between
-- households demanding, offered, and availing employment.
-- These checks identify recorded anomalies; source values are retained.

SELECT
    j.original_label,
    fy.label,
    m.hh_demanded,
    m.hh_offered,
    m.hh_availed
FROM mis_annual_indicators AS m
JOIN jurisdictions AS j
    ON m.jurisdiction_id = j.jurisdiction_id
JOIN financial_years AS fy
    ON m.fin_year_id = fy.fin_year_id
WHERE m.hh_offered > m.hh_demanded
   OR m.hh_availed > m.hh_offered;