{% macro check_oauth_usage_for_sources(framework, check_id) %}
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