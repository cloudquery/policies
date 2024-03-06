SELECT line_item_product_code, SUM(line_item_unblended_cost) as cost
FROM {{ var('cost_usage_table') }}
where line_item_line_item_type = 'Usage'
GROUP BY line_item_product_code
HAVING SUM(line_item_unblended_cost) > 0
ORDER BY SUM(line_item_unblended_cost) DESC