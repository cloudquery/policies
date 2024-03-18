select 
    line_item_product_code as ProductName,
    product_product_family as ProductFamily,
    line_item_usage_type,
    sum(cast(line_item_usage_amount AS double precision)) as sum_line_item_usage_amount_hours
from 
  {{ var('cost_usage_table') }}
where 
  line_item_line_item_type like '%Usage%'
group by
    line_item_product_code,
    product_product_family,
	  line_item_usage_type