{% macro project_environment_should_not_have_privileged_mode(framework, check_id) %}
  {{ return(adapter.dispatch('project_environment_should_not_have_privileged_mode')(framework, check_id)) }}
{% endmacro %}

{% macro default__project_environment_should_not_have_privileged_mode(framework, check_id) %}{% endmacro %}

{% macro postgres__project_environment_should_not_have_privileged_mode(framework, check_id) %}
select 
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CodeBuild project environments should not have privileged mode enabled' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN (logs_config -> 'environment' ->> 'PrivilegedMode')::boolean then 'fail'
    ELSE 'pass'
    END as status
from aws_codebuild_projects
{% endmacro %}

{% macro snowflake__project_environment_should_not_have_privileged_mode(framework, check_id) %}
select 
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CodeBuild project environments should not have privileged mode enabled' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN logs_config:environment:PrivilegedMode::boolean then 'fail'
    ELSE 'pass'
    END as status
from aws_codebuild_projects
{% endmacro %}

{% macro bigquery__project_environment_should_not_have_privileged_mode(framework, check_id) %}
select 
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CodeBuild project environments should not have privileged mode enabled' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN CAST( JSON_VALUE(logs_config.environment.PrivilegedMode) AS BOOL) then 'fail'
    ELSE 'pass'
    END as status
from 
     {{ full_table_name("aws_codebuild_projects") }}
{% endmacro %}

{% macro snowflake__project_environment_should_not_have_privileged_mode(framework, check_id) %}
select 
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CodeBuild project environments should not have privileged mode enabled' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN cast(json_extract_scalar(logs_config, '$.environment.PrivilegedMode') as boolean) then 'fail'
    ELSE 'pass'
    END as status
from aws_codebuild_projects
{% endmacro %}