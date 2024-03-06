WITH totals AS (
    SELECT 
        line_item_line_item_type AS type, 
        SUM(line_item_unblended_cost) AS total
    FROM {{ var('cost_usage_table') }}
    WHERE line_item_line_item_type IN ('Credit', 'Usage')
    GROUP BY line_item_line_item_type
)
SELECT 'Credit' AS type, total
FROM totals
WHERE type = 'Credit'

UNION

SELECT 'Usage' AS type, total
FROM totals
WHERE type = 'Usage'

UNION

SELECT 'Overall' AS type, SUM(total) AS total
FROM totals