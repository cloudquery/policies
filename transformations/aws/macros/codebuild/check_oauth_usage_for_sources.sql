{% macro check_oauth_usage_for_sources(framework, check_id) %}
  {{ return(adapter.dispatch('check_oauth_usage_for_sources')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__check_oauth_usage_for_sources(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'CodeBuild GitHub or Bitbucket source repository URLs should use OAuth' as title,
    account_id,
    arn as resource_id,
    case when
        source:Type IN ('GITHUB', 'BITBUCKET') AND source:Auth:Type != 'OAUTH'
      then 'fail'
      else 'pass'
    end as status
from aws_codebuild_projects
{% endmacro %}

{% macro postgres__check_oauth_usage_for_sources(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'CodeBuild GitHub or Bitbucket source repository URLs should use OAuth' as title,
    account_id,
    arn as resource_id,
    case when
        source->>'Type' IN ('GITHUB', 'BITBUCKET') AND source->'Auth'->>'Type' != 'OAUTH'
      then 'fail'
      else 'pass'
    end as status
from aws_codebuild_projects
{% endmacro %}

{% macro default__check_oauth_usage_for_sources(framework, check_id) %}{% endmacro %}

{% macro bigquery__check_oauth_usage_for_sources(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'CodeBuild GitHub or Bitbucket source repository URLs should use OAuth' as title,
    account_id,
    arn as resource_id,
    case when
        JSON_VALUE(source.Type) IN ('GITHUB', 'BITBUCKET') AND JSON_VALUE(source.Auth.Type) != 'OAUTH'
      then 'fail'
      else 'pass'
    end as status
from {{ full_table_name("aws_codebuild_projects") }}
{% endmacro %}

{% macro athena__check_oauth_usage_for_sources(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'CodeBuild GitHub or Bitbucket source repository URLs should use OAuth' as title,
    account_id,
    arn as resource_id,
    case when
        json_extract_scalar(source, '$.Type') IN ('GITHUB', 'BITBUCKET') AND json_extract_scalar(source, '$.Auth.Type') != 'OAUTH'
      then 'fail'
      else 'pass'
    end as status
from aws_codebuild_projects
{% endmacro %}