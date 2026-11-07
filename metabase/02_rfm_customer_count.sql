-- Metabase Question: Customer count and LTV by RFM segment

select rfm_segment, customer_count, avg_ltv_eur, total_revenue_eur
from {{project}}.metrics.mart_rfm_segmentation
order by total_revenue_eur desc
