{% macro unused_acm_certs(framework, check_id) %}
  {{ return(adapter.dispatch('unused_acm_certs')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_acm_certs(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_acm_certs(framework, check_id) %}
select
       c.account_id,
       c.arn                      as resource_id,
       rbc.cost
from aws_acm_certificates c
JOIN {{ ref('aws_cost__by_resources') }} rbc ON c.arn = rbc.line_item_resource_id 
where array_length(c.in_use_by, 1) = 0
{% endmacro %}

{% macro snowflake__unused_acm_certs(framework, check_id) %}
{% endmacro %}