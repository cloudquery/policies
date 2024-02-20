with tags as
(select 
identity_line_item_id,
jsonb_array_elements(resource_tags::jsonb) ->> 'key' as aws_tag_key, 
jsonb_array_elements(resource_tags::jsonb) ->> 'value' as aws_tag_value,
extract(month from bill_billing_period_start_date) as month,
from {{ var('cost_usage_table') }}
group by identity_line_item_id, aws_tag_key, aws_tag_value)
select tags.aws_tag_key,
tags.aws_tag_value,
sum(line_item_unblended_cost) as sum_line_item_unblended_cost
from
{{ var('cost_usage_table') }} cur
left join tags on cur.identity_line_item_id = tags.identity_line_item_id
group by tags.aws_tag_key, tags.aws_tag_value, month
having sum(line_item_unblended_cost) > 0