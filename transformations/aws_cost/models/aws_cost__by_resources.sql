SELECT
  line_item_resource_id,
  line_item_product_code,
  sum(line_item_blended_cost) AS cost
FROM {{ var('cost_usage_table') }}
WHERE line_item_resource_id !=''
GROUP BY line_item_resource_id, line_item_product_code
HAVING sum(line_item_blended_cost) > 0
ORDER BY cost DESC