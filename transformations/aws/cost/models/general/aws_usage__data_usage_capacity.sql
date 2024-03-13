select 
    product_product_name as ProductName,
    product_product_family as ProductFamily,
    line_item_usage_type,
    product_vcpu,
    sum(cast(line_item_usage_amount AS double precision)) as sum_line_item_usage_amount_hours
from 
  {{ var('cost_usage_table') }}
where 
  product_vcpu is not null
  and line_item_line_item_type like '%Usage%'
group by
    product_product_name,
    product_product_family,
	line_item_usage_type,
    product_vcpu


