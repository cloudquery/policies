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
                    