
CHECK_OAUTH_USAGE_FOR_SOURCES = """
INSERT INTO aws_policy_results
SELECT DISTINCT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
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
WHERE $where:aws_codebuild_projects$
"""

CHECK_ENVIRONMENT_VARIABLES = """
insert into aws_policy_results
select distinct
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
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
where $where:aws_codebuild_projects$
"""
