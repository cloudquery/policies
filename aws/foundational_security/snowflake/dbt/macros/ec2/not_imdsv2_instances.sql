{% macro not_imdsv2_instances(framework, check_id) %}
insert into aws_policy_results
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'EC2 instances should use IMDSv2' as title,
  account_id,
  instance_id as resource_id,
  case when
    metadata_options:HttpTokens is distinct from 'required'
    then 'fail'
    else 'pass'
  end as status
from aws_ec2_instances
{% endmacro %}