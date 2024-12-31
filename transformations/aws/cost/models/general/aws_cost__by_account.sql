select
bill_payer_account_id as account_id,
sum(line_item_unblended_cost) as cost
from {{ adapter.quote(var('cost_usage_table')) }}
where line_item_line_item_type = 'Usage'
group by bill_payer_account_id
having sum(line_item_unblended_cost) > 0

-- SELECT line_item_usage_account_id, SUM(line_item_unblended_cost) as cost
-- FROM {{ adapter.quote(var('cost_usage_table')) }}
-- GROUP BY line_item_usage_account_id
-- HAVING SUM(line_item_unblended_cost) > 0
-- ORDER BY SUM(line_item_unblended_cost) DESC