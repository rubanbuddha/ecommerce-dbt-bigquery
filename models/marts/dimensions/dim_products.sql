{{ config(materialized = 'table') }}

select
    product_id as product_key,
    product_id,
    product_name,
    category,
    brand,
    list_price_eur
from {{ ref('stg_ecommerce__products') }}
