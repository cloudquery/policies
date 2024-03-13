SELECT
  SUM(line_item_unblended_cost) AS total_cost
FROM {{ var('cost_usage_table') }}
WHERE
  line_item_product_code = 'AmazonEC2'
  AND
  line_item_resource_id like 'i-%'
group by 
line_item_resource_id