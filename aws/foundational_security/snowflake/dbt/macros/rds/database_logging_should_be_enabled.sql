{% macro database_logging_should_be_enabled(framework, check_id) %}
INSERT INTO aws_policy_results
SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Database logging should be enabled' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN enabled_cloudwatch_logs_exports IS NULL THEN 'fail'
        WHEN engine IN ('aurora', 'aurora-mysql', 'mariadb', 'mysql') 
             AND (NOT ARRAY_CONTAINS(PARSE_JSON(enabled_cloudwatch_logs_exports::VARCHAR)::VARIANT, 
                  ARRAY_CONSTRUCT('audit', 'error', 'general', 'slowquery'))) THEN 'fail'
        WHEN engine LIKE '%postgres%' 
             AND (NOT ARRAY_CONTAINS(PARSE_JSON(enabled_cloudwatch_logs_exports::VARCHAR)::VARIANT, 
                  ARRAY_CONSTRUCT('postgresql', 'upgrade'))) THEN 'fail'
        WHEN engine LIKE '%oracle%' 
             AND (NOT ARRAY_CONTAINS(PARSE_JSON(enabled_cloudwatch_logs_exports::VARCHAR)::VARIANT, 
                  ARRAY_CONSTRUCT('alert', 'audit', 'trace', 'listener'))) THEN 'fail'
        WHEN engine LIKE '%sqlserver%' 
             AND (NOT ARRAY_CONTAINS(PARSE_JSON(enabled_cloudwatch_logs_exports::VARCHAR)::VARIANT, 
                  ARRAY_CONSTRUCT('error', 'agent'))) THEN 'fail'
        ELSE 'pass' 
    END AS status
FROM aws_rds_instances;
{% endmacro %}