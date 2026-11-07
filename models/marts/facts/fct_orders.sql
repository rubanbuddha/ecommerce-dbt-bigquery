{{ config(materialized = 'table') }}

select
    order_id,
    customer_id,
    order_date,
    ordered_at,
    status,
    payment_method,
    total_eur,
    order_seq,
    days_since_prev_order,
    case when order_seq = 1 then true else false end as is_first_order
from {{ ref('int_customer_orders') }}
