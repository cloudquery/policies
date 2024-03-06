with product_stats as (
SELECT
line_item_product_code,
avg(cost) as mean_cost,
stddev(cost) as std_cost
FROM {{ ref('aws_cost__by_resources') }}
GROUP BY line_item_product_code
)

SELECT line_item_product_code,
line_item_resource_id,
cost,
mean_cost,
std_cost
FROM {{ ref('aws_cost__by_resources') }}
INNER JOIN product_stats using(line_item_product_code)
WHERE cost >= mean_cost + 2 * std_cost