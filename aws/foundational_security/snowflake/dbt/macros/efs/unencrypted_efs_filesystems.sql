{% macro unencrypted_efs_filesystems(framework, check_id) %}
insert into aws_policy_results
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