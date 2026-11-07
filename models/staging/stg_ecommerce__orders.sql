{{ config(materialized = 'view') }}

select
    order_id,
    customer_id,
    cast(ordered_at as timestamp) as ordered_at,
    date(ordered_at)              as order_date,
    status,
    cast(total_eur as numeric)    as total_eur,
    payment_method
from {{ source('raw_ecommerce', 'orders') }}
where status != 'cancelled'
