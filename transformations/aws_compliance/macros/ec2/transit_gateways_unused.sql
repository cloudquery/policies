{% macro transit_gateways_unused(framework, check_id) %}
  {{ return(adapter.dispatch('transit_gateways_unused')(framework, check_id)) }}
{% endmacro %}

{% macro default__transit_gateways_unused(framework, check_id) %}{% endmacro %}

{% macro postgres__transit_gateways_unused(framework, check_id) %}
with attachment as (select distinct transit_gateway_arn from aws_ec2_transit_gateway_attachments)
select
       '{{framework}}'             as framework,
       '{{check_id}}'              as check_id,
       'Unused transit gateway' as title,
       gateway.account_id,
       gateway.arn              as resource_id,
       'fail'                   as status
from aws_ec2_transit_gateways gateway
         left join attachment on attachment.transit_gateway_arn = gateway.arn
where attachment.transit_gateway_arn is null;{% endmacro %}
