{{ config(materialized = 'view') }}

select
    product_id,
    product_name,
    category,
    brand,
    cast(list_price_eur as numeric) as list_price_eur
from {{ source('raw_ecommerce', 'products') }}
