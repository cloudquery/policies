ATHENA_WORKGROUP_ENCRYPTED_AT_REST = """
INSERT INTO aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Athena workgroups should be encrypted at rest' AS "title",
  account_id,
  arn as resource_id,
  case  
        WHEN CONFIGURATION:ResultConfiguration:EncryptionConfiguration::STRING IS NULL THEN 'fail'
        else 'pass' end as status
from aws_athena_work_groups;
"""
