---cloudformation tags
with all_costs as (
	select resource_tags_aws_cloudformation_logical_id as cloudformation_logical_id,
	resource_tags_aws_cloudformation_stack_name as cloudformation_stack_name,
	identity_time_interval,
	sum(line_item_unblended_cost) as sum_line_item_unblended_cost
	from kevin_cost_00001_snappy
	group by resource_tags_aws_cloudformation_logical_id, resource_tags_aws_cloudformation_stack_name, identity_time_interval
),
cost_calcs as (
select 
*,
sum(sum_line_item_unblended_cost) over (partition by identity_time_interval) as sum_spend,

sum(case when cloudformation_logical_id is null and cloudformation_stack_name is null 
then sum_line_item_unblended_cost else 0 end) 
over (partition by identity_time_interval) as untagged_spend,

sum(case when cloudformation_logical_id is not null and cloudformation_stack_name is not null 
then sum_line_item_unblended_cost else 0 end) 
over (partition by identity_time_interval) as tagged_spend,

case when cloudformation_logical_id is not null and cloudformation_stack_name is not null 
then sum_line_item_unblended_cost/sum(case when cloudformation_logical_id is not null and cloudformation_stack_name is not null 
then sum_line_item_unblended_cost else 0 end) over (partition by identity_time_interval) else 0 end as percent_spend


from all_costs) 
select *,
percent_spend * untagged_spend as untagged_cost_distribution,
case when cloudformation_logical_id is not null and cloudformation_stack_name is not null
then (percent_spend * untagged_spend)+sum_line_item_unblended_cost else 0 end as chargeback

from cost_calcs
;