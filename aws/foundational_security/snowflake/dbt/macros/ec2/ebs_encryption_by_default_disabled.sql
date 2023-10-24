{% macro ebs_encryption_by_default_disabled(framework, check_id) %}
insert into aws_policy_results
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'EBS default encryption should be enabled' as title,
  account_id,
  concat(account_id,':',region) as resource_id,
  case when
    ebs_encryption_enabled_by_default is distinct from true
    then 'fail'
    else 'pass'
  end as status
from aws_ec2_regional_configs
{% endmacro %}