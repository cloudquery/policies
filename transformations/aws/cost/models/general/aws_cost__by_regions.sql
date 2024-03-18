SELECT
  product_location,
  SUM(line_item_unblended_cost) AS cost
FROM {{ var('cost_usage_table') }}
WHERE line_item_resource_id !='' and product_location_type = 'AWS Region'
GROUP BY product_location
HAVING SUM(line_item_unblended_cost) > 0
ORDER BY cost DESC