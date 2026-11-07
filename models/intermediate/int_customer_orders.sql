-- Per-customer order history with running order number and gap between orders.

with orders as (
    select * from {{ ref('stg_ecommerce__orders') }}
)

select
    *,
    row_number() over (partition by customer_id order by ordered_at) as order_seq,
    lag(ordered_at) over (partition by customer_id order by ordered_at) as prev_order_at,
    timestamp_diff(
        ordered_at,
        lag(ordered_at) over (partition by customer_id order by ordered_at),
        day
    ) as days_since_prev_order
from orders
