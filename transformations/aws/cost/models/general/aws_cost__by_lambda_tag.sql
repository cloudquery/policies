select resource_tags_aws_lambda_function_name as lambda_function_name,
extract(month from bill_billing_period_start_date) as month,
sum(line_item_unblended_cost) as sum_line_item_unblended_cost
from {{ adapter.quote(var('cost_usage_table')) }}
group by resource_tags_aws_lambda_function_name, month
having sum(line_item_unblended_cost) > 0