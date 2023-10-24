{% macro appsync_should_have_logging_turned_on(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'AWS AppSync should have request-level and field-level logging turned on' as title, 
    account_id, 
    arn as resource_id,
    CASE
        WHEN (log_config:cloudWatchLogsRoleArn IS NULL OR log_config:cloudWatchLogsRoleArn::STRING = '')
            OR 
            log_config:fieldLogLevel = 'NONE' THEN 'fail'
        ELSE 'pass'
    END AS status
FROM aws_appsync_graphql_apis
{% endmacro %}