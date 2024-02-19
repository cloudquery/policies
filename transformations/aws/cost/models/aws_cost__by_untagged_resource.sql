select 
bill_payer_account_id,
line_item_resource_id,
product_servicecode,
extract(month from bill_billing_period_start_date) as month,
sum(line_item_unblended_cost) as sum_line_item_unblended_cost
from
{{ var('cost_usage_table') }}
where resource_tags = '[]' or resource_tags is null
group by bill_payer_account_id, line_item_resource_id, product_servicecode, month
having sum(line_item_unblended_cost) > 0;