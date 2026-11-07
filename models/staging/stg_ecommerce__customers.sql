{{ config(materialized = 'view') }}

select
    customer_id,
    first_name,
    last_name,
    lower(email) as email,
    country,
    cast(signed_up_at as timestamp) as signed_up_at
from {{ source('raw_ecommerce', 'customers') }}
