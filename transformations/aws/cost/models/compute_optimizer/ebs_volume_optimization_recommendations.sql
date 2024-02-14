/*
This query combines Amazon EBS volume recommendations with volume details, associated resources, and cost information.
It helps users understand the current performance and configuration of their EBS volumes, 
as well as recommendations for optimizing performance and potentially reducing costs.
*/

SELECT 
    r.account_id,
    volume_arn,
		eev.attachments ->> 'associatedResource' as ecs_attached,
		eev.encrypted,
		eev.fast_restored,
		eev.availability_zone,
		eev.region,
		eev.snapshot_id,
		eev.sse_type,
    current_performance_risk,
    finding,
    current_configuration ->> 'volumeBaselineIOPS' AS current_baseline_iops,
    (volume_recommendation_options -> 'configuration' ->> 'volumeBaselineIOPS')::int AS recommended_baseline_iops,
    current_configuration ->> 'volumeBaselineThroughput' AS current_baseline_throughput,
    (volume_recommendation_options -> 'configuration' ->> 'volumeBaselineThroughput')::int AS recommended_baseline_throughput,
    current_configuration ->> 'volumeBurstIOPS' AS current_burst_iops,
    (volume_recommendation_options -> 'configuration' ->> 'volumeBurstIOPS')::int AS recommended_burst_iops,
    current_configuration ->> 'volumeBurstThroughput' AS current_burst_throughput,
    (volume_recommendation_options -> 'configuration' ->> 'volumeBurstThroughput')::int AS recommended_burst_throughput,
    current_configuration ->> 'volumeSize' AS current_volume_size,
    (volume_recommendation_options -> 'configuration' ->> 'volumeSize')::int AS recommended_volume_size,
    current_configuration ->> 'volumeType' AS current_volume_type,
    volume_recommendation_options -> 'configuration' ->> 'volumeType' AS recommended_volume_type,
	cost_resources.cost
FROM 
    aws_computeoptimizer_ebs_volume_recommendations r
LEFT JOIN
    aws_ec2_ebs_volumes as eev ON eev.arn = r.volume_arn
LEFT JOIN
	{{ ref('aws_cost__by_resources') }} as cost_resources on cost_resources.line_item_resource_id = r.volume_arn