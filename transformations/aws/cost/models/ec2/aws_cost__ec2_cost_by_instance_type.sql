SELECT
  ec2.instance_type,
  SUM(cu.line_item_unblended_cost) AS cost
FROM
  {{ var('cost_usage_table') }} AS cu
JOIN
  aws_ec2_instances AS ec2
ON
  cu.line_item_resource_id = ec2.instance_id
WHERE
  cu.line_item_line_item_type = 'Usage'
  AND line_item_product_code = 'AmazonEC2'
GROUP BY
  ec2.instance_type
HAVING
  SUM(cu.line_item_unblended_cost) > 0
ORDER BY
  SUM(cu.line_item_unblended_cost) DESC