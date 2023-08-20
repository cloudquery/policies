KINESIS_STREAM_ENCRYPTED = """
INSERT INTO aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Kinesis streams should be encrypted at rest' as title,
  account_id,
  arn as resource_id,
  case  
        WHEN ENCRYPTION_TYPE = 'KMS' THEN 'pass'
        else 'fail' end as status
from aws_kinesis_streams;
"""