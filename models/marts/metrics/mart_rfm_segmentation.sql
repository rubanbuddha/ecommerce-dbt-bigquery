{{ config(materialized = 'table') }}

select
    rfm_segment,
    count(*)                             as customer_count,
    round(avg(lifetime_revenue_eur), 2)  as avg_ltv_eur,
    round(sum(lifetime_revenue_eur), 2)  as total_revenue_eur,
    round(avg(order_count), 2)           as avg_orders,
    round(avg(days_since_last_order), 1) as avg_days_since_last_order
from {{ ref('dim_customers') }}
group by rfm_segment
order by total_revenue_eur desc
