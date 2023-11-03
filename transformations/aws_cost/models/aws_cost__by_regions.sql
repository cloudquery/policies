SELECT
  product_location,
  sum(line_item_blended_cost) AS cost
FROM {{ var('cost_usage_table') }}
WHERE line_item_resource_id !='' and product_location_type = 'AWS Region'
GROUP BY product_location
HAVING sum(line_item_blended_cost) > 0
ORDER BY cost DESC