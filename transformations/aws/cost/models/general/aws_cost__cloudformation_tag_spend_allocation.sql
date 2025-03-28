---cloudformation tags
with all_costs as (
	select resource_tags_aws_cloudformation_logical_id as cloudformation_logical_id,
	resource_tags_aws_cloudformation_stack_name as cloudformation_stack_name,
	extract(month from bill_billing_period_start_date) as month,
	sum(line_item_unblended_cost) as sum_line_item_unblended_cost
	from {{ adapter.quote(var('cost_usage_table')) }}
	group by resource_tags_aws_cloudformation_logical_id, resource_tags_aws_cloudformation_stack_name, month
),
cost_calcs as (
select 
*,
sum(sum_line_item_unblended_cost) over (partition by month) as sum_spend,

sum(case when cloudformation_logical_id is null and cloudformation_stack_name is null 
then sum_line_item_unblended_cost else 0 end) 
over (partition by month) as untagged_spend,

sum(case when cloudformation_logical_id is not null and cloudformation_stack_name is not null 
then sum_line_item_unblended_cost else 0 end) 
over (partition by month) as tagged_spend,

case when cloudformation_logical_id is not null and cloudformation_stack_name is not null 
then sum_line_item_unblended_cost/sum(case when cloudformation_logical_id is not null and cloudformation_stack_name is not null 
then sum_line_item_unblended_cost else 0 end) over (partition by month) else 0 end as percent_spend


from all_costs) 
select *,
percent_spend * untagged_spend as untagged_cost_distribution,
case when cloudformation_logical_id is not null and cloudformation_stack_name is not null
then (percent_spend * untagged_spend)+sum_line_item_unblended_cost else 0 end as chargeback

from cost_calcs