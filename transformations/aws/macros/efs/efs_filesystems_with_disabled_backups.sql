{% macro efs_filesystems_with_disabled_backups(framework, check_id) %}
  {{ return(adapter.dispatch('efs_filesystems_with_disabled_backups')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__efs_filesystems_with_disabled_backups(framework, check_id) %}
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

{% macro postgres__efs_filesystems_with_disabled_backups(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
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

{% macro default__efs_filesystems_with_disabled_backups(framework, check_id) %}{% endmacro %}

{% macro bigquery__efs_filesystems_with_disabled_backups(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Amazon EFS volumes should be in backup plans' as title,
  account_id,
  arn as resource_id,
  case when
    backup_policy_status is distinct from 'ENABLED'
    then 'fail'
    else 'pass'
  end as status
from {{ full_table_name("aws_efs_filesystems") }}
{% endmacro %}