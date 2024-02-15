/*This query combines Amazon ECS service recommendations with service details and cost information.
 It helps users understand performance risks, recommendations for container resources, and cost implications,
 enabling more informed and cost-effective management of ECS services.
*/
with containers as (
SELECT 
    cer.account_id,
		cer.service_arn,
    cer.current_performance_risk,
    cer.finding,
    cer.finding_reason_codes,
    container_recommendation->>'cpu' AS container_cpu_recommendation,
    container_recommendation->>'memorySizeConfiguration' AS container_memory_size_recommendation
FROM 
    aws_computeoptimizer_ecs_service_recommendations as cer,
	jsonb_array_elements(cer.service_recommendation_options->'containerRecommendations') AS container_recommendation

) 
select 
		cer.account_id,
		cer.service_arn,
		ecs.service_name,
		ecs.region,
  	cer.current_performance_risk,
  	cer.finding,
  	cer.finding_reason_codes,
  	container_cpu_recommendation,
  	container_memory_size_recommendation,
		ecs.status,
		ecs.tags,
		ecs.cluster_arn,
		ecs.desired_count,
		ecs.launch_type,
		ecs.load_balancers,
		ecs.platform_family,
		ecs.platform_version,
		ecs.running_count,
		cost_resources.cost as cost
from containers as cer
LEFT JOIN 
    aws_ecs_cluster_services as ecs ON ecs.arn = cer.service_arn
LEFT JOIN 
{{ ref('aws_cost__by_resources') }}  as cost_resources on cost_resources.line_item_resource_id = cer.service_arn