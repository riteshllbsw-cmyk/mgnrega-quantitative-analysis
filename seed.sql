
BEGIN;

-- Seed reference data for the MGNREGA project.
-- Financial years covered: 2014-15 to 2024-25.

INSERT INTO financial_years (fin_year_id, label, start_year)
VALUES
    (1, '2014-15', 2014),
    (2, '2015-16', 2015),
    (3, '2016-17', 2016),
    (4, '2017-18', 2017),
    (5, '2018-19', 2018),
    (6, '2019-20', 2019),
    (7, '2020-21', 2020),
    (8, '2021-22', 2021),
    (9, '2022-23', 2022),
    (10, '2023-24', 2023),
    (11, '2024-25', 2024);



-- Seed jurisdiction reference data.
-- Labels are preserved from the source MIS reports.

INSERT INTO jurisdictions (
    jurisdiction_id,
    original_label,
    jurisdiction_type,
    analysis_unit
)
VALUES
    (1,  'ANDHRA PRADESH',       'State', 'ANDHRA PRADESH'),
    (2,  'ARUNACHAL PRADESH',    'State', 'ARUNACHAL PRADESH'),
    (3,  'ASSAM',                'State', 'ASSAM'),
    (4,  'BIHAR',                'State', 'BIHAR'),
    (5,  'CHHATTISGARH',         'State', 'CHHATTISGARH'),
    (6,  'GOA',                  'State', 'GOA'),
    (7,  'GUJARAT',              'State', 'GUJARAT'),
    (8,  'HARYANA',              'State', 'HARYANA'),
    (9,  'HIMACHAL PRADESH',     'State', 'HIMACHAL PRADESH'),
    (10, 'JAMMU AND KASHMIR',    'UT',    'JAMMU AND KASHMIR'),
    (11, 'JHARKHAND',            'State', 'JHARKHAND'),
    (12, 'KARNATAKA',            'State', 'KARNATAKA'),
    (13, 'LADAKH',               'UT',    'LADAKH'),
    (14, 'MADHYA PRADESH',       'State', 'MADHYA PRADESH'),
    (15, 'MANIPUR',              'State', 'MANIPUR'),
    (16, 'MEGHALAYA',            'State', 'MEGHALAYA'),
    (17, 'MIZORAM',              'State', 'MIZORAM'),
    (18, 'NAGALAND',             'State', 'NAGALAND'),
    (19, 'ODISHA',               'State', 'ODISHA'),
    (20, 'PUNJAB',               'State', 'PUNJAB'),
    (21, 'RAJASTHAN',            'State', 'RAJASTHAN'),
    (22, 'SIKKIM',               'State', 'SIKKIM'),
    (23, 'TAMIL NADU',           'State', 'TAMIL NADU'),
    (24, 'TELANGANA',             'State', 'TELANGANA'),
    (25, 'TRIPURA',              'State', 'TRIPURA'),
    (26, 'UTTAR PRADESH',        'State', 'UTTAR PRADESH'),
    (27, 'UTTARAKHAND',          'State', 'UTTARAKHAND'),
    (28, 'WEST BENGAL',          'State', 'WEST BENGAL'),
    (29, 'ANDAMAN AND NICOBAR',  'UT',    'ANDAMAN AND NICOBAR'),
    (30, 'DN HAVELI AND DD',     'UT',    'DN HAVELI AND DD'),
    (31, 'LAKSHADWEEP',          'UT',    'LAKSHADWEEP'),
    (32, 'PUDUCHERRY',           'UT',    'PUDUCHERRY');

-- Populate annual indicators from the consolidated CSV staging table.
-- Jurisdiction and financial-year IDs are resolved through reference labels.

INSERT INTO mis_annual_indicators (
    jurisdiction_id,
    fin_year_id,
    hh_demanded,
    hh_offered,
    hh_availed,
    persondays_total,
    hh_completed_100_days
)
SELECT
    j.jurisdiction_id,
    fy.fin_year_id,
    CAST(s.employment_demanded_household AS INTEGER),
    CAST(s.employment_offered_household AS INTEGER),
    CAST(s.employment_availed_household AS INTEGER),
    CAST(s.total_persondays AS INTEGER),
    CAST(s.families_completed_100_days AS INTEGER)
FROM temp.consolidated_staging AS s
JOIN jurisdictions AS j
    ON j.original_label = s.jurisdiction
JOIN financial_years AS fy
    ON fy.label = s.fin_year;

DROP TABLE temp.consolidated_staging;

COMMIT;
