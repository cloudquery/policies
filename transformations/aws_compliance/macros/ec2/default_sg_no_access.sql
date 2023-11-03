{% macro default_sg_no_access(framework, check_id) %}
  {{ return(adapter.dispatch('default_sg_no_access')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__default_sg_no_access(framework, check_id) %}
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

{% macro postgres__default_sg_no_access(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'The VPC default security group should not allow inbound and outbound traffic' as title,
  account_id,
  arn,
  case when
      group_name='default' 
      AND (jsonb_array_length(ip_permissions) > 0
      OR jsonb_array_length(ip_permissions_egress) > 0)
      then 'fail'
      else 'pass'
  end
from
    aws_ec2_security_groups
{% endmacro %}
