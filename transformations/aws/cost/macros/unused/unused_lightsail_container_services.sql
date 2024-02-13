{% macro unused_lightsail_container_services(framework, check_id) %}
  {{ return(adapter.dispatch('unused_lightsail_container_services')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_lightsail_container_services(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_lightsail_container_services(framework, check_id) %}
SELECT 
    cs.account_id,
    cs.resource_id,
    rbc.cost,
       'lightsail_container_services' as resource_type
FROM (
select 
       cs.account_id,
       cs.arn                                as resource_id
from aws_lightsail_container_services cs
         left join (select distinct sd.container_service_arn from aws_lightsail_container_service_deployments sd) deployment on deployment.container_service_arn = cs.arn
where deployment.container_service_arn is null) cs
JOIN {{ ref('aws_cost__by_resources') }} rbc ON cs.resource_id = rbc.line_item_resource_id
{% endmacro %}

{% macro snowflake__unused_lightsail_container_services(framework, check_id) %}

{% endmacro %}