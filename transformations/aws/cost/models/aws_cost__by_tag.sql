with raw_tags as
(
	SELECT 
    identity_line_item_id,
    COALESCE(tags.aws_tag_key, 'untagged') AS aws_tag_key,
    COALESCE(tags.aws_tag_value, 'untagged') AS aws_tag_value,
    EXTRACT(month FROM bill_billing_period_start_date) AS month,
	line_item_unblended_cost
FROM 
    {{ var('cost_usage_table') }}
LEFT JOIN LATERAL (
    SELECT
        jsonb_array_elements(resource_tags::jsonb) ->> 'key' AS aws_tag_key,
        jsonb_array_elements(resource_tags::jsonb) ->> 'value' AS aws_tag_value
) AS tags ON true
)
select 
case 
    when aws_tag_key = 'untagged' then 'untagged' 
    else aws_tag_key || '|' || aws_tag_value
    end as tag,
sum(line_item_unblended_cost) as sum_line_item_unblended_cost
from raw_tags
group by aws_tag_key, aws_tag_value, month
having sum(line_item_unblended_cost) > 0