/*
This query provides detailed insights into optimizing your EC2 instances, including cost considerations.
 It includes information such as the account ID, instance ARN, region, state, tags, instance type, and architecture.
 Additionally, it extracts details like GPU information, recommended instance type, migration effort, 
performance risk, and platform differences from the recommendation options, 
helping you make informed decisions to optimize both performance and cost efficiency.
*/
SELECT
    r.account_id,
    r.instance_arn,
    region,
    state,
    r.tags,
    instance_type,
    architecture,
    ami_launch_index,
    private_ip_address,
    ipv6_address,
		current_performance_risk,
		current_instance_gpu_info ->> 'gpus' as current_gpus,
    recommendation_options -> 'instanceGpuInfo' ->> 'gpus' as recommended_gpus,
		current_instance_type,
    recommendation_options ->> 'instanceType' as recommended_instance_type,
    recommendation_options ->> 'migrationEffort' as migration_effort,
    recommendation_options ->> 'performanceRisk' as recommended_performance_risk,
    recommendation_options ->> 'platformDifferences' as platform_differences,
		cost_resources.cost as cost
FROM
    aws_computeoptimizer_ec2_instance_recommendations r
LEFT JOIN
    aws_ec2_instances as aei ON aei.arn = r.instance_arn
LEFT JOIN 
{{ ref('aws_cost__by_resources') }} as cost_resources on cost_resources.line_item_resource_id = r.instance_arn