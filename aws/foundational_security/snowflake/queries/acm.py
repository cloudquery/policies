import datetime
from snowflake.connector import SnowflakeConnection

CERTIFICATES_SHOULD_BE_RENEWED = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
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

RSA_CERTIFICATE_KEY_LENGTH_SHOULD_BE_MORE_THAN_2048_BITS = """
 insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'rsa certificate key length is less than 2048 bits' as title,
  account_id,
  arn AS resource_id,
  case when
    left(key_algorithm, 3) = 'RSA' and split_part(key_algorithm, '-', 2)::INTEGER < 2048
    then 'fail'
    else 'pass'
  end as status
FROM aws_acm_certificates
"""
