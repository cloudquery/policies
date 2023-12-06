{% macro unused_ec2_network_acls(framework, check_id) %}
  {{ return(adapter.dispatch('unused_ec2_network_acls')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_ec2_network_acls(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_ec2_network_acls(framework, check_id) %}
select 
       a.account_id,
       a.arn                                  as resource_id,
       rbc.cost
from aws_ec2_network_acls a
JOIN {{ ref('aws_cost__by_resources') }} rbc ON a.arn = rbc.line_item_resource_id
where coalesce(jsonb_array_length(a.associations), 0) = 0
{% endmacro %}

{% macro snowflake__unused_ec2_network_acls(framework, check_id) %}
{% endmacro %}