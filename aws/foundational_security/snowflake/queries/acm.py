import datetime
from snowflake.connector import SnowflakeConnection

CERTIFICATES_SHOULD_BE_RENEWED = """
insert into aws_policy_results
select
  %s as execution_time,
  %s as framework,
  %s as check_id,
  'certificate has less than 30 days to be renewed' as title,
  account_id,
  arn AS resource_id,
  case when
    not_after < DATEADD('day', 30, CURRENT_TIMESTAMP()::timestamp_ntz)
    then 'fail'
    else 'pass'
  end as status
FROM aws_acm_certificates
"""
