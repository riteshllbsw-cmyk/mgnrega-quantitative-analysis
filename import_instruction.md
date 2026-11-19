
# Annual CSV Import Instructions

## 1. Prepare the staging table

Open SQLite in the project directory:

```bash
sqlite3 mgnrega.db
```

Create the staging table if this is a fresh database:

```sql
.read staging.sql
```

## 2. Import one financial year

Exit the SQLite prompt, then run this command in the terminal:

```bash
sqlite3 mgnrega.db ".mode csv" ".import --skip 5 data/staging/mis_employment_generated_2014-15.csv staging_raw"
```

The `--skip 5` option skips the first five lines of the CSV, including the report title and header rows.

## 3. Validate the staging rows

Open SQLite and run:

```sql
SELECT COUNT(*) FROM staging_raw;
```

For the 2014-15 file, the expected count is 34:
- 1 numbered-column row
- 32 jurisdiction rows
- 1 Total row
