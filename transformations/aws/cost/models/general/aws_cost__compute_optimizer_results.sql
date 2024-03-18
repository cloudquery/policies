with computeoptimizer as (
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
from aws_computeoptimizer_autoscaling_group_recommendations)
SELECT computeoptimizer.*, rc.cost
FROM computeoptimizer
LEFT JOIN {{ ref('aws_cost__by_resources') }} rc
	ON computeoptimizer.arn = rc.line_item_resource_id


