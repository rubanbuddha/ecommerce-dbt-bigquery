{{ config(materialized = 'table') }}

select
    i.order_item_id,
    i.order_id,
    o.customer_id,
    o.order_date,
    i.product_id,
    i.quantity,
    i.unit_price_eur,
    i.line_total_eur
from {{ ref('stg_ecommerce__order_items') }} i
left join {{ ref('fct_orders') }} o using (order_id)
