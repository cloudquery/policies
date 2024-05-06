{% macro elbv1_have_multiple_availability_zones(framework, check_id) %}
  {{ return(adapter.dispatch('elbv1_have_multiple_availability_zones')(framework, check_id)) }}
{% endmacro %}

{% macro default__elbv1_have_multiple_availability_zones(framework, check_id) %}{% endmacro %}

{% macro postgres__elbv1_have_multiple_availability_zones(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Classic Load Balancer should span multiple Availability Zones' as title,
    account_id,
    arn as resource_id,
    case
        WHEN array_length(availability_zones, 1) > 1 THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    aws_elbv1_load_balancers
{% endmacro %}

{% macro snowflake__elbv1_have_multiple_availability_zones(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Classic Load Balancer should span multiple Availability Zones' as title,
    account_id,
    arn as resource_id,
    case
        WHEN array_size(availability_zones) > 1 THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    aws_elbv1_load_balancers
{% endmacro %}

{% macro bigquery__elbv1_have_multiple_availability_zones(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Classic Load Balancer should span multiple Availability Zones' as title,
    account_id,
    arn as resource_id,
    case
        WHEN ARRAY_LENGTH(availability_zones) > 1 THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    {{ full_table_name("aws_elbv1_load_balancers") }}
{% endmacro %}

{% macro athena__elbv1_have_multiple_availability_zones(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Classic Load Balancer should span multiple Availability Zones' as title,
    account_id,
    arn as resource_id,
    case
        WHEN cardinality(availability_zones) > 1 THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    aws_elbv1_load_balancers
{% endmacro %}