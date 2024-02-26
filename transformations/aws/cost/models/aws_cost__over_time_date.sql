SELECT
  DATE(line_item_usage_end_date) AS usage_date,
  SUM(line_item_blended_cost) AS total_cost
FROM {{ var('cost_usage_table') }}
WHERE
  line_item_resource_id != '' AND
  product_location_type = 'AWS Region'
GROUP BY DATE(line_item_usage_end_date)
HAVING SUM(line_item_blended_cost) > 0
ORDER BY usage_date ASC