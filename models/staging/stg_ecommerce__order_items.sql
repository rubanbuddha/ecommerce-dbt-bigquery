{{ config(materialized = 'view') }}

select
    order_item_id,
    order_id,
    product_id,
    cast(quantity as int64)                    as quantity,
    cast(unit_price_eur as numeric)            as unit_price_eur,
    cast(quantity * unit_price_eur as numeric) as line_total_eur
from {{ source('raw_ecommerce', 'order_items') }}
