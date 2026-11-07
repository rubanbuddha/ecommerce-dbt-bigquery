{{ config(materialized = 'table') }}

-- Monthly cohort retention. Rows: cohort month. Column (months_since_cohort): offset. Value: active customers.

with first_orders as (
    select
        customer_id,
        date_trunc(min(order_date), month) as cohort_month
    from {{ ref('fct_orders') }}
    group by customer_id
),

activity as (
    select
        customer_id,
        date_trunc(order_date, month) as activity_month
    from {{ ref('fct_orders') }}
    group by customer_id, date_trunc(order_date, month)
),

cohort_size as (
    select cohort_month, count(distinct customer_id) as cohort_size
    from first_orders
    group by cohort_month
),

aggregated as (
    select
        f.cohort_month,
        date_diff(a.activity_month, f.cohort_month, month) as months_since_cohort,
        count(distinct a.customer_id) as active_customers
    from first_orders f
    join activity a using (customer_id)
    group by f.cohort_month, date_diff(a.activity_month, f.cohort_month, month)
)

select
    a.cohort_month,
    a.months_since_cohort,
    a.active_customers,
    c.cohort_size,
    safe_divide(a.active_customers, c.cohort_size) as retention_rate
from aggregated a
join cohort_size c using (cohort_month)
order by a.cohort_month, a.months_since_cohort
