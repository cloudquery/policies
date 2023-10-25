{% macro flow_logs_enabled_in_all_vpcs(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'VPC flow logging should be enabled in all VPCs' as title,
  aws_ec2_vpcs.account_id,
  aws_ec2_vpcs.arn,
  case when
      aws_ec2_flow_logs.resource_id is null
      then 'fail'
      else 'pass'
  end
from aws_ec2_vpcs
left join aws_ec2_flow_logs on
        aws_ec2_vpcs.vpc_id = aws_ec2_flow_logs.resource_id
{% endmacro %}