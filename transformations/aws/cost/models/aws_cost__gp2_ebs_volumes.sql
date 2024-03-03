SELECT
  costquery.line_item_resource_id,
  costquery.cost,
  vols.volume_type,
  vols.attachments,
  vols.arn,
  vols.tags,
  vols.state,
  vols.snapshot_id,
  vols.size,
  vols.create_time
FROM (
	SELECT
	  line_item_resource_id, line_item_product_code,
    SUM(line_item_unblended_cost) AS cost
	FROM {{ var('cost_usage_table') }}
	WHERE
    line_item_resource_id LIKE 'vol-%'
	GROUP BY
    line_item_resource_id, line_item_product_code
	HAVING SUM(line_item_unblended_cost) > 0
	ORDER BY cost DESC
) as costquery
LEFT JOIN "aws_ec2_ebs_volumes" as vols
ON costquery.line_item_resource_id = vols.volume_id
WHERE vols.volume_type = 'gp2'
