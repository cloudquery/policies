{% macro default_sg_no_access(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'The VPC default security group should not allow inbound and outbound traffic' AS title,
  account_id,
  arn,
  case when
      group_name='default'
      and (array_size(parse_json(ip_permissions)) > 0 or array_size(parse_json(ip_permissions_egress)) > 0)
      then 'fail'
      else 'pass'
  end
FROM
    aws_ec2_security_groups
{% endmacro %}