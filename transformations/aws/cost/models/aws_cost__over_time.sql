SELECT
  line_item_usage_start_date,
  line_item_usage_end_date,
  SUM(line_item_unblended_cost) AS cost
FROM {{ var('cost_usage_table') }}
WHERE line_item_resource_id !='' and product_location_type = 'AWS Region'
GROUP BY line_item_usage_start_date, line_item_usage_end_date
HAVING SUM(line_item_unblended_cost) > 0
ORDER BY line_item_usage_start_date asc