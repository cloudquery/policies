{% macro unused_ec2_transit_gateways(framework, check_id) %}
  {{ return(adapter.dispatch('unused_ec2_transit_gateways')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_ec2_transit_gateways(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_ec2_transit_gateways(framework, check_id) %}
SELECT 
    ug.account_id,
    ug.resource_id,
    rbc.cost,
       'ec2_transit_gateways' as resource_type
FROM (
select 
       gateway.account_id,
       gateway.arn              as resource_id
from aws_ec2_transit_gateways gateway
         left join (select distinct ga.transit_gateway_arn from aws_ec2_transit_gateway_attachments ga) attachment on attachment.transit_gateway_arn = gateway.arn
where attachment.transit_gateway_arn is null) ug
JOIN {{ ref('aws_cost__by_resources') }} rbc ON ug.resource_id = rbc.line_item_resource_id
{% endmacro %}

{% macro snowflake__unused_ec2_transit_gateways(framework, check_id) %}

{% endmacro %}