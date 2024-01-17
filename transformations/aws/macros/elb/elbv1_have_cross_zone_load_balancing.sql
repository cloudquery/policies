{% macro elbv1_have_cross_zone_load_balancing(framework, check_id) %}
  {{ return(adapter.dispatch('elbv1_have_cross_zone_load_balancing')(framework, check_id)) }}
{% endmacro %}

{% macro default__elbv1_have_cross_zone_load_balancing(framework, check_id) %}{% endmacro %}

{% macro postgres__elbv1_have_cross_zone_load_balancing(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Classic Load Balancers should have cross-zone load balancing enabled' as title,
    account_id,
    arn as resource_id,
    case
        WHEN attributes -> 'CrossZoneLoadBalancing' ->> 'Enabled' = 'true' THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    aws_elbv1_load_balancers
{% endmacro %}

{% macro snowflake__elbv1_have_cross_zone_load_balancing(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Classic Load Balancers should have cross-zone load balancing enabled' as title,
    account_id,
    arn as resource_id,
    case
        WHEN attributes:CrossZoneLoadBalancing:Enabled = 'true' THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    aws_elbv1_load_balancers  
{% endmacro %}