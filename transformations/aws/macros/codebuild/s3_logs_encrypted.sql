{% macro s3_logs_encrypted(framework, check_id) %}
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