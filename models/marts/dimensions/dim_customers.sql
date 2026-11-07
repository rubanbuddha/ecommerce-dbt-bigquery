{{ config(materialized = 'table') }}

with customers as (
    select * from {{ ref('stg_ecommerce__customers') }}
),

orders as (
    select
        customer_id,
        count(*)                                              as order_count,
        sum(total_eur)                                        as lifetime_revenue_eur,
        min(ordered_at)                                       as first_order_at,
        max(ordered_at)                                       as last_order_at,
        date_diff(current_date(), date(max(ordered_at)), day) as days_since_last_order
    from {{ ref('stg_ecommerce__orders') }}
    group by customer_id
),

enriched as (
    select
        c.customer_id, c.first_name, c.last_name, c.email, c.country, c.signed_up_at,
        coalesce(o.order_count, 0)          as order_count,
        coalesce(o.lifetime_revenue_eur, 0) as lifetime_revenue_eur,
        o.first_order_at, o.last_order_at, o.days_since_last_order
    from customers c
    left join orders o using (customer_id)
),

rfm as (
    select
        *,
        ntile(5) over (order by days_since_last_order desc) as recency_quintile,
        ntile(5) over (order by order_count)                as frequency_quintile,
        ntile(5) over (order by lifetime_revenue_eur)       as monetary_quintile
    from enriched
    where order_count > 0
)

select
    customer_id, first_name, last_name, email, country, signed_up_at,
    order_count, lifetime_revenue_eur,
    first_order_at, last_order_at, days_since_last_order,
    recency_quintile   as r_score,
    frequency_quintile as f_score,
    monetary_quintile  as m_score,
    recency_quintile + frequency_quintile + monetary_quintile as rfm_total,
    case
        when recency_quintile >= 4 and frequency_quintile >= 4 then 'Champions'
        when recency_quintile >= 4 and frequency_quintile <= 2 then 'Recent'
        when recency_quintile <= 2 and frequency_quintile >= 4 then 'At-risk loyal'
        when recency_quintile <= 2 and frequency_quintile <= 2 then 'Lapsed'
        else 'Potential'
    end as rfm_segment
from rfm
