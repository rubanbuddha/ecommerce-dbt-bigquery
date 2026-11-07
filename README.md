# E-Commerce dbt Analytics Warehouse on BigQuery

Modular dbt project rebuilding a monolithic BI query stack as a layered Kimball warehouse — the pattern Analytics Engineering teams actually ship.

## What's inside

- **35+ dbt models** across `stg_`, `int_`, `dim_`, `fct_` layers
- **RFM customer segmentation**, **cohort retention**, and **executive KPI mart**
- **90+ dbt tests** (unique, not-null, accepted-values, referential integrity, custom)
- Column-level docs, **exposures** for Metabase, rendered `dbt docs`
- **GitHub Actions CI** running `dbt build --select state:modified+`
- **Metabase questions** pointing only at certified mart models

## Stack

BigQuery, dbt 1.7+, sqlfluff, Metabase, GitHub Actions, Claude Code.

## Advanced SQL used

CTEs, `RANK()`, `NTILE(5)` for RFM quintiles, `LAG()` for cohort progression, running totals, self-joins, and `dbt_utils.date_spine` for the calendar dimension.

## Local setup

```bash
git clone https://github.com/rubanbuddha/ecommerce-dbt-bigquery.git
cd ecommerce-dbt-bigquery
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
cp profiles.yml.example ~/.dbt/profiles.yml
dbt deps && dbt seed && dbt build
dbt docs generate && dbt docs serve
```

## License

MIT
