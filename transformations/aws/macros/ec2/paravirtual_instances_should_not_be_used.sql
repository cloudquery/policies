{% macro paravirtual_instances_should_not_be_used(framework, check_id) %}
  {{ return(adapter.dispatch('paravirtual_instances_should_not_be_used')(framework, check_id)) }}
{% endmacro %}

{% macro default__paravirtual_instances_should_not_be_used(framework, check_id) %}{% endmacro %}

{% macro postgres__paravirtual_instances_should_not_be_used(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon EC2 paravirtual instance types should not be used' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN virtualization_type = 'paravirtual' THEN 'fail'
    ELSE 'pass'
    END as status
FROM aws_ec2_instances
{% endmacro %}

{% macro snowflake__paravirtual_instances_should_not_be_used(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon EC2 paravirtual instance types should not be used' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN virtualization_type = 'paravirtual' THEN 'fail'
    ELSE 'pass'
    END as status
FROM aws_ec2_instances
{% endmacro %}

{% macro bigquery__paravirtual_instances_should_not_be_used(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon EC2 paravirtual instance types should not be used' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN virtualization_type = 'paravirtual' THEN 'fail'
    ELSE 'pass'
    END as status
FROM {{ full_table_name("aws_ec2_instances") }}
{% endmacro %}

{% macro athena__paravirtual_instances_should_not_be_used(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Amazon EC2 paravirtual instance types should not be used' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN virtualization_type = 'paravirtual' THEN 'fail'
    ELSE 'pass'
    END as status
FROM aws_ec2_instances
{% endmacro %}
