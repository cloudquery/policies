select resource_tags_aws_cloudformation_logical_id as cloudformation_logical_id,
resource_tags_aws_cloudformation_stack_name as cloudformation_stack_name,
extract(month from bill_billing_period_start_date) as month,
sum(line_item_unblended_cost) as sum_line_item_unblended_cost
from {{ var('cost_usage_table') }}
group by resource_tags_aws_cloudformation_logical_id, resource_tags_aws_cloudformation_stack_name, month
having sum(line_item_unblended_cost) > 0