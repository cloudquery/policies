{% macro check_oauth_usage_for_sources(framework, check_id) %}
  {{ return(adapter.dispatch('check_oauth_usage_for_sources')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__check_oauth_usage_for_sources(framework, check_id) %}
select DISTINCT
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'CodeBuild project environment variables should not contain clear text credentials' as title,
  account_id,
  arn as resource_id,
  CASE WHEN
    e.VALUE:Type::STRING = 'PLAINTEXT'
    AND (
      UPPER(e.VALUE:Name::STRING) LIKE '%ACCESS_KEY%'
      OR UPPER(e.VALUE:Name::STRING) LIKE '%SECRET%'
      OR UPPER(e.VALUE:Name::STRING) LIKE '%PASSWORD%'
    )
    THEN 'fail'
  ELSE 'pass'
  END as status
FROM aws_codebuild_projects, 
LATERAL FLATTEN(input => environment:EnvironmentVariables) as e
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
