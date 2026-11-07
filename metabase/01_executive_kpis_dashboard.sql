-- Metabase Question: Monthly revenue and MoM growth
-- Points at certified mart only — never at staging or sources.

select
    month_start,
    revenue_eur,
    orders,
    aov_eur,
    repeat_order_rate,
    revenue_mom_growth
from {{project}}.metrics.mart_executive_kpis
order by month_start desc
limit 24
