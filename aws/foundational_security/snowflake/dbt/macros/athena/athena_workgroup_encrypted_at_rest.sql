{% macro athena_workgroup_encrypted_at_rest(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Athena workgroups should be encrypted at rest' AS "title",
  account_id,
  arn as resource_id,
  case  
        WHEN CONFIGURATION:ResultConfiguration:EncryptionConfiguration::STRING IS NULL THEN 'fail'
        else 'pass' end as status
from aws_athena_work_groups
{% endmacro %}