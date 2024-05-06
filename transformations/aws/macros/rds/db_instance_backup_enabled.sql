{% macro db_instance_backup_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('db_instance_backup_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__db_instance_backup_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__db_instance_backup_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS instances should have automatic backups enabled' as title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN backup_retention_period IS NULL
            OR backup_retention_period < 7 THEN 'fail'
        ELSE 'pass'
    END AS status
FROM
    aws_rds_instances
{% endmacro %}

{% macro snowflake__db_instance_backup_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS instances should have automatic backups enabled' as title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN backup_retention_period IS NULL
            OR backup_retention_period < 7 THEN 'fail'
        ELSE 'pass'
    END AS status
FROM
    aws_rds_instances
{% endmacro %}

{% macro bigquery__db_instance_backup_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS instances should have automatic backups enabled' as title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN backup_retention_period IS NULL
            OR backup_retention_period < 7 THEN 'fail'
        ELSE 'pass'
    END AS status
FROM {{ full_table_name("aws_rds_instances") }}
{% endmacro %}

{% macro athena__db_instance_backup_enabled(framework, check_id) %}
SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'RDS instances should have automatic backups enabled' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN backup_retention_period IS NULL OR backup_retention_period < 7 THEN 'fail'
        ELSE 'pass'
    END AS status
FROM aws_rds_instances
{% endmacro %}