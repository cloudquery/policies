select resource_tags_aws_ecs_cluster as ecs_cluster,
extract(month from bill_billing_period_start_date) as month,
sum(line_item_unblended_cost) as sum_line_item_unblended_cost
from {{ var('cost_usage_table') }}
group by resource_tags_aws_ecs_cluster, month
having sum(line_item_unblended_cost) > 0