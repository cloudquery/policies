UNENCRYPTED_EFS_FILESYSTEMS = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Amazon EFS should be configured to encrypt file data at rest using AWS KMS' as title,
  account_id,
  arn as resource_id,
  case when
    encrypted is distinct from TRUE
    or kms_key_id is null
    then 'fail'
    else 'pass'
  end as status
from aws_efs_filesystems
"""

EFS_FILESYSTEMS_WITH_DISABLED_BACKUPS = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Amazon EFS volumes should be in backup plans' as title,
  account_id,
  arn as resource_id,
  case when
    backup_policy_status is distinct from 'ENABLED'
    then 'fail'
    else 'pass'
  end as status
from aws_efs_filesystems
"""