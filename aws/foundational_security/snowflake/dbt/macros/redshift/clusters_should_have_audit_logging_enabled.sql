{% macro clusters_should_have_audit_logging_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon Redshift clusters should have audit logging enabled' AS title,
    account_id,
    arn AS resource_id,
    CASE WHEN 
        IFNULL(logging_status:LoggingEnabled::STRING, 'false') != 'true'
    THEN 'fail' ELSE 'pass' END AS status
FROM aws_redshift_clusters
{% endmacro %}