RESOURCES_BY_COST = """
CREATE OR REPLACE VIEW resources_by_cost as
SELECT
  line_item_resource_id,
  line_item_product_code,
  sum(line_item_blended_cost) AS cost
FROM {table}
WHERE line_item_resource_id !=''
GROUP BY line_item_resource_id, line_item_product_code
HAVING sum(line_item_blended_cost) > 0
ORDER BY cost DESC;
"""

REGIONS_BY_COST = """
CREATE OR REPLACE VIEW regions_by_cost as
SELECT
  product_location,
  sum(line_item_blended_cost) AS cost
FROM {table}
WHERE line_item_resource_id !='' and product_location_type = 'AWS Region'
GROUP BY product_location
HAVING sum(line_item_blended_cost) > 0
ORDER BY cost DESC;
"""

COST_OVER_TIME = """
CREATE OR REPLACE VIEW cost_over_time as
SELECT
  line_item_usage_start_date,
  line_item_usage_end_date,
  sum(line_item_blended_cost) AS cost
FROM {table}
WHERE line_item_resource_id !='' and product_location_type = 'AWS Region'
GROUP BY line_item_usage_start_date, line_item_usage_end_date
HAVING sum(line_item_blended_cost) > 0
ORDER BY line_item_usage_start_date asc;
"""

GCP2_EBS_VOLUMES = """
CREATE OR REPLACE VIEW gcp2_ebs_volumes as
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
    SUM(line_item_blended_cost) AS cost
	FROM {table}
	WHERE
    line_item_resource_id LIKE 'vol-%'
	GROUP BY
    line_item_resource_id, line_item_product_code
	HAVING SUM(line_item_blended_cost) > 0
	ORDER BY cost DESC
) as costquery
LEFT JOIN "aws_ec2_ebs_volumes" as vols
ON costquery.line_item_resource_id = vols.volume_id
WHERE vols.volume_type = 'gp2'
"""

#AWS Compute Optimizer Section
#TODO: Separate this out to a different file
COMPUTE_OPTIMIZER_RESULTS = """
CREATE OR REPLACE VIEW compute_optimizer_results as
SELECT *
FROM (  
	SELECT account_id,  instance_arn as arn, recommendation_options as roptions
  	FROM aws_computeoptimizer_ec2_instance_recommendations
  	UNION
  	SELECT account_id,  function_arn as arn, memory_size_recommendation_options as roptions 
  	FROM aws_computeoptimizer_lambda_function_recommendations
  	UNION
  	SELECT account_id, volume_arn as arn, volume_recommendation_options as roptions 
  	FROM aws_computeoptimizer_ebs_volume_recommendations 
  	UNION
	SELECT account_id, service_arn as arn, service_recommendation_options as roptions
	FROM aws_computeoptimizer_ecs_service_recommendations
  	UNION
	SELECT account_id, auto_scaling_group_arn as arn,  recommendation_options as roptions
	from aws_computeoptimizer_autoscaling_group_recommendations
) as compute_opt
"""
