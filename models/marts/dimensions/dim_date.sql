{{ config(materialized = 'table') }}

with dates as (
    {{ dbt_utils.date_spine(
        datepart = "day",
        start_date = "cast('2022-01-01' as date)",
        end_date = "date_add(current_date(), interval 365 day)"
    ) }}
)

select
    date_day                                   as date_key,
    date_day,
    extract(year from date_day)                as year,
    extract(quarter from date_day)             as quarter,
    extract(month from date_day)               as month,
    format_date('%B', date_day)                as month_name,
    date_trunc(date_day, month)                as month_start_date,
    extract(dayofweek from date_day) in (1, 7) as is_weekend
from dates
