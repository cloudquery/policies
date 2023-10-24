{% macro efs_filesystems_with_disabled_backups(framework, check_id) %}
insert into aws_policy_results
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Amazon EFS volumes should be in backup plans' as title,
  account_id,
  arn as resource_id,
  case when
    backup_policy_status is distinct from 'ENABLED'
    then 'fail'
    else 'pass'
  end as status
from aws_efs_filesystems
{% endmacro %}