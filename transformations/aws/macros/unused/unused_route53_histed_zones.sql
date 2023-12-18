{% macro unused_route53_histed_zones(framework, check_id) %}
  {{ return(adapter.dispatch('unused_route53_histed_zones')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_route53_histed_zones(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_route53_histed_zones(framework, check_id) %}
select 
       hz.account_id,
       hz.arn                            as resource_id,
       rbc.cost
from aws_route53_hosted_zones hz
JOIN {{ ref('aws_cost__by_resources') }} rbc ON hz.arn = rbc.line_item_resource_id
where hz.resource_record_set_count = 0
{% endmacro %}

{% macro snowflake__unused_route53_histed_zones(framework, check_id) %}
{% endmacro %}