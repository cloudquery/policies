{% macro rds_instance_default_admin_check(framework, check_id) %}
  {{ return(adapter.dispatch('rds_instance_default_admin_check')(framework, check_id)) }}
{% endmacro %}

{% macro default__rds_instance_default_admin_check(framework, check_id) %}{% endmacro %}

{% macro postgres__rds_instance_default_admin_check(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS database instances should use a custom administrator username' as title,
    account_id,
    arn AS resource_id,
    CASE
        WHEN master_username NOT IN ('admin', 'root', 'administrator', 'master', 'sa', 'awsuser') THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_rds_instances
{% endmacro %}

{% macro snowflake__rds_instance_default_admin_check(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS database instances should use a custom administrator username' as title,
    account_id,
    arn AS resource_id,
    CASE
        WHEN master_username NOT IN ('admin', 'root', 'administrator', 'master', 'sa', 'awsuser') THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_rds_instances
{% endmacro %}