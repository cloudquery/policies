{% macro elbv2_have_multiple_availability_zones(framework, check_id) %}
  {{ return(adapter.dispatch('elbv2_have_multiple_availability_zones')(framework, check_id)) }}
{% endmacro %}

{% macro default__elbv2_have_multiple_availability_zones(framework, check_id) %}{% endmacro %}

{% macro postgres__elbv2_have_multiple_availability_zones(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Application, Network and Gateway Load Balancers should span multiple Availability Zones' as title,
    account_id,
    arn as resource_id,
    case
        WHEN jsonb_array_length(availability_zones) > 1 THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    aws_elbv2_load_balancers 
{% endmacro %}

{% macro snowflake__elbv2_have_multiple_availability_zones(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Application, Network and Gateway Load Balancers should span multiple Availability Zones' as title,
    account_id,
    arn as resource_id,
    case
        WHEN array_size(availability_zones) > 1 THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    aws_elbv2_load_balancers 
{% endmacro %}