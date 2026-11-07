{{ config(materialized = 'table') }}

-- Monthly executive KPIs: revenue, orders, AOV, repeat rate, MoM growth, cumulative revenue.

with monthly as (
    select
        date_trunc(order_date, month) as month_start,
        count(*)                      as orders,
        count(distinct customer_id)   as active_customers,
        sum(total_eur)                as revenue_eur,
        countif(is_first_order)       as new_customer_orders
    from {{ ref('fct_orders') }}
    group by date_trunc(order_date, month)
)

select
    month_start,
    orders,
    active_customers,
    revenue_eur,
    new_customer_orders,
    orders - new_customer_orders                      as repeat_orders,
    safe_divide(orders - new_customer_orders, orders) as repeat_order_rate,
    safe_divide(revenue_eur, orders)                  as aov_eur,
    safe_divide(
        revenue_eur - lag(revenue_eur) over (order by month_start),
        lag(revenue_eur) over (order by month_start)
    ) as revenue_mom_growth,
    sum(revenue_eur) over (
        order by month_start
        rows between unbounded preceding and current row
    ) as cumulative_revenue
from monthly
order by month_start
