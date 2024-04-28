{% macro unencrypted_efs_filesystems(framework, check_id) %}
  {{ return(adapter.dispatch('unencrypted_efs_filesystems')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__unencrypted_efs_filesystems(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
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
{% endmacro %}

{% macro postgres__unencrypted_efs_filesystems(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
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
{% endmacro %}

{% macro default__unencrypted_efs_filesystems(framework, check_id) %}{% endmacro %}

{% macro bigquery__unencrypted_efs_filesystems(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Amazon EFS should be configured to encrypt file data at rest using AWS KMS' as title,
  account_id,
  arn as resource_id,
  case when
    encrypted is distinct from TRUE
    or kms_key_id is null
    then 'fail'
    else 'pass'
  end as status
from {{ full_table_name("aws_efs_filesystems") }}
{% endmacro %}

{% macro athena__unencrypted_efs_filesystems(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
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
{% endmacro %}