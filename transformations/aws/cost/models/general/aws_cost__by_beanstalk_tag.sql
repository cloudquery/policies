select resource_tags_aws_elasticbeanstalk_environment_id as elasticbeanstalk_environment_id,
extract(month from bill_billing_period_start_date) as month,
sum(line_item_unblended_cost) as sum_line_item_unblended_cost
from {{ adapter.quote(var('cost_usage_table')) }}
group by resource_tags_aws_elasticbeanstalk_environment_id, month
having sum(line_item_unblended_cost) > 0