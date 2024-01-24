{% macro s3_logs_encrypted(framework, check_id) %}
  {{ return(adapter.dispatch('s3_logs_encrypted')(framework, check_id)) }}
{% endmacro %}

{% macro default__s3_logs_encrypted(framework, check_id) %}{% endmacro %}

{% macro postgres__s3_logs_encrypted(framework, check_id) %}
select 
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CodeBuild S3 logs should be encrypted' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN (logs_config -> 'S3Logs' ->> 'encryptionDisabled')::boolean then 'fail'
    ELSE 'pass'
    END as status
from aws_codebuild_projects
{% endmacro %}

{% macro snowflake__s3_logs_encrypted(framework, check_id) %}
select 
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CodeBuild S3 logs should be encrypted' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN logs_config:S3Logs:encryptionDisabled::boolean then 'fail'
    ELSE 'pass'
    END as status
from aws_codebuild_projects
{% endmacro %}

{% macro bigquery__s3_logs_encrypted(framework, check_id) %}
select 
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CodeBuild S3 logs should be encrypted' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN CAST( JSON_VALUE(logs_config.S3Logs.encryptionDisabled) AS BOOL) then 'fail'
    ELSE 'pass'
    END as status
from {{ full_table_name("aws_codebuild_projects") }}
{% endmacro %}