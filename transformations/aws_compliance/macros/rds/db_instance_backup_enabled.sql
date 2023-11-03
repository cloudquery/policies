{% macro db_instance_backup_enabled(framework, check_id) %}
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