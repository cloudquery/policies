{% macro check_environment_variables(framework, check_id) %}
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