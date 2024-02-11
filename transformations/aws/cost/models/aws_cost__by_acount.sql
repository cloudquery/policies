SELECT line_item_usage_account_id, SUM(line_item_unblended_cost) as cost
FROM {{ var('cost_usage_table') }}
GROUP BY line_item_usage_account_id
HAVING SUM(line_item_unblended_cost) > 0
ORDER BY SUM(line_item_unblended_cost) DESC