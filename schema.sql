CREATE TABLE financial_years (
    fin_year_id INTEGER PRIMARY KEY,
    label TEXT NOT NULL UNIQUE,
    start_year INTEGER NOT NULL UNIQUE
);

CREATE TABLE jurisdictions (
    jurisdiction_id INTEGER PRIMARY KEY,
    original_label TEXT NOT NULL UNIQUE,
    jurisdiction_type TEXT NOT NULL
        CHECK (jurisdiction_type IN ('State', 'UT')),
    analysis_unit TEXT NOT NULL
);

CREATE TABLE mis_annual_indicators (
    jurisdiction_id INTEGER NOT NULL REFERENCES jurisdictions(jurisdiction_id),
    fin_year_id INTEGER NOT NULL REFERENCES financial_years(fin_year_id),
    hh_demanded INTEGER CHECK (hh_demanded >= 0),
    hh_offered INTEGER CHECK (hh_offered >= 0),
    hh_availed INTEGER CHECK (hh_availed >= 0),
    persondays_total INTEGER CHECK (persondays_total >= 0),
    hh_completed_100_days INTEGER CHECK (hh_completed_100_days >= 0),
    PRIMARY KEY (jurisdiction_id, fin_year_id)
);