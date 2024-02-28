select
bill_payer_account_id as account_id,
sum(line_item_unblended_cost) as cost
from {{ var('cost_usage_table') }}
where line_item_line_item_type = 'Usage'
group by bill_payer_account_id
having sum(line_item_unblended_cost) > 0