SELECT
  DATE(line_item_usage_end_date) AS usage_date,
  SUM(line_item_unblended_cost) AS total_cost
FROM {{ adapter.quote(var('cost_usage_table')) }}
WHERE
  line_item_product_code = 'AmazonEC2'
  AND
  line_item_resource_id like 'i-%'
GROUP BY DATE(line_item_usage_end_date)
HAVING SUM(line_item_unblended_cost) > 0
ORDER BY usage_date ASC