with ec2_cost as (

select 
'arn:aws:ec2:' || product_region_code::text || ':' || line_item_usage_account_id::text || ':instance/' || line_item_resource_id::text AS arn,
product_region_code as region,
SUM(line_item_unblended_cost) AS cost
from {{ var('cost_usage_table') }}
where line_item_product_code = 'AmazonEC2'
and line_item_resource_id like 'i-%'
group by arn, region

)
select 
ec.arn,
instance_type,
ec.region,
ec.cost
from ec2_cost as ec
join aws_ec2_instances as ei on ei.arn = ec.arn