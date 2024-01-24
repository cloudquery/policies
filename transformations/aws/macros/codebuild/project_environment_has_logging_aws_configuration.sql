{% macro project_environment_has_logging_aws_configuration(framework, check_id) %}
  {{ return(adapter.dispatch('project_environment_has_logging_aws_configuration')(framework, check_id)) }}
{% endmacro %}

{% macro default__project_environment_has_logging_aws_configuration(framework, check_id) %}{% endmacro %}

{% macro postgres__project_environment_has_logging_aws_configuration(framework, check_id) %}
select 
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CodeBuild project environments should have a logging AWS Configuration' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN (logs_config -> 'S3Logs' ->> 'status' = 'ENABLED')
        or (logs_config -> 'CloudWatchLogs' ->>'status' = 'ENABLED')
    then 'pass'
    ELSE 'fail'
    END as status
from aws_codebuild_projects
{% endmacro %}

{% macro snowflake__project_environment_has_logging_aws_configuration(framework, check_id) %}
select 
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CodeBuild project environments should have a logging AWS Configuration' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN logs_config:S3Logs:status::text = 'ENABLED' then 'pass'
    WHEN logs_config:CloudWatchLogs:status::text = 'ENABLED' then 'pass'
    ELSE 'fail'
    END as status
from aws_codebuild_projects
{% endmacro %}

{% macro bigquery__project_environment_has_logging_aws_configuration(framework, check_id) %}
select 
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CodeBuild project environments should have a logging AWS Configuration' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN CAST(JSON_VALUE(logs_config.S3Logs.status) AS STRING) = 'ENABLED' then 'pass'
    WHEN CAST(JSON_VALUE(logs_config.CloudWatchLogs.status) AS STRING) = 'ENABLED' then 'pass'
    ELSE 'fail'
    END as status
from 
     {{ full_table_name("aws_codebuild_projects") }}
{% endmacro %}