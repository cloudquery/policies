SELECT product_region_code, SUM(line_item_unblended_cost) as cost
FROM {{ var('cost_usage_table') }}
where line_item_line_item_type = 'Usage'
AND line_item_product_code = 'AmazonEC2'
AND line_item_resource_id like 'i-%'
GROUP BY product_region_code
HAVING SUM(line_item_unblended_cost) > 0
ORDER BY SUM(line_item_unblended_cost) DESC