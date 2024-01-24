{% macro check_environment_variables(framework, check_id) %}
  {{ return(adapter.dispatch('check_environment_variables')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__check_environment_variables(framework, check_id) %}
select distinct
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CodeBuild project environment variables should not contain clear text credentials' as title,
    account_id,
    arn as resource_id,
    case when
            e.Value:Type = 'PLAINTEXT'
            and (
                UPPER(e.Value:Name) like '%ACCESS_KEY%' or
                UPPER(e.Value:Name) like '%SECRET%' or
                UPPER(e.Value:Name) like '%PASSWORD%'
            )
            then 'fail'
        else 'pass'
    end as status
from aws_codebuild_projects, LATERAL FLATTEN(input => environment:EnvironmentVariables) as e
{% endmacro %}

{% macro postgres__check_environment_variables(framework, check_id) %}
select distinct
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'CodeBuild project environment variables should not contain clear text credentials' as title,
    account_id,
    arn as resource_id,
    case when
            e->>'Type' = 'PLAINTEXT'
            and (
                UPPER(e->>'Name') like '%ACCESS_KEY%' or
                UPPER(e->>'Name') like '%SECRET%' or
                UPPER(e->>'Name') like '%PASSWORD%'
            )
            then 'fail'
        else 'pass'
    end as status
from aws_codebuild_projects, JSONB_ARRAY_ELEMENTS(environment->'EnvironmentVariables') as e
{% endmacro %}

{% macro default__check_environment_variables(framework, check_id) %}{% endmacro %}
{% macro bigquery__check_environment_variables(framework, check_id) %}
select distinct
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'CodeBuild project environment variables should not contain clear text credentials' as title,
    account_id,
    arn as resource_id,
    case when
            JSON_VALUE(e.Type) = 'PLAINTEXT'
            and (
                UPPER(JSON_VALUE(e.Name)) like '%ACCESS_KEY%' or
                UPPER(JSON_VALUE(e.Name)) like '%SECRET%' or
                UPPER(JSON_VALUE(e.Name)) like '%PASSWORD%'
            )
            then 'fail'
        else 'pass'
    end as status
from {{ full_table_name("aws_codebuild_projects") }},
UNNEST(JSON_QUERY_ARRAY(environment.EnvironmentVariables)) AS e
{% endmacro %}