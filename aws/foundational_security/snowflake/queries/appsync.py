
#AppSync.2
APPSYNC_SHOULD_HAVE_LOGGING_TURNED_ON = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
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
"""