/*
This query retrieves recommendations for optimizing AWS Auto Scaling Groups from AWS Compute Optimizer.
It includes details such as the account ID, ARN, and name of the Auto Scaling Group, 
as well as various performance metrics and configuration details.
*/

SELECT
    r.account_id,
    r.auto_scaling_group_arn,
    r.auto_scaling_group_name,
		aag.region,
		status,
    current_performance_risk,
    finding,
    inferred_workload_types AS inferred_workload_types,
    current_configuration ->> 'desiredCapacity' as current_desired_capacity,
    recommendation_options -> 'AutoScalingGroupConfiguration' ->> 'desiredCapacity' as recommended_desired_capacity,
    current_configuration ->> 'instanceType' as current_instance_type,
    recommendation_options -> 'AutoScalingGroupConfiguration' ->> 'instanceType' as recommended_instance_type,
    current_configuration ->> 'maxSize' as current_max_size,
    recommendation_options -> 'AutoScalingGroupConfiguration' ->> 'maxSize' as recommended_max_size,
    current_configuration ->> 'minSize' as current_min_size,
    recommendation_options -> 'AutoScalingGroupConfiguration' ->> 'minSize' as recommended_min_size,
    current_instance_gpu_info ->> 'gpus' as current_gpus,
    recommendation_options -> 'AutoScalingGroupConfiguration' ->> 'gpus' as recommended_gpus,
    recommendation_options -> 'AutoScalingGroupConfiguration' ->> 'migrationEffort' as migration_effort,
    recommendation_options -> 'AutoScalingGroupConfiguration' ->> 'performanceRisk' as recommended_performance_risk,
    cost_resources.cost as cost
FROM
    aws_computeoptimizer_autoscaling_group_recommendations r
LEFT JOIN
    aws_autoscaling_groups as aag ON aag.arn = r.auto_scaling_group_arn
LEFT JOIN 
    {{ ref('aws_cost__by_resources') }} as cost_resources on cost_resources.line_item_resource_id = r.auto_scaling_group_arn