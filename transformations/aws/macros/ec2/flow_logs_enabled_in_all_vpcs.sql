{% macro flow_logs_enabled_in_all_vpcs(framework, check_id) %}
  {{ return(adapter.dispatch('flow_logs_enabled_in_all_vpcs')(framework, check_id)) }}
{% endmacro %}

{% macro default__flow_logs_enabled_in_all_vpcs(framework, check_id) %}{% endmacro %}

{% macro snowflake__flow_logs_enabled_in_all_vpcs(framework, check_id) %}
select
  DISTINCT
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'VPC flow logging should be enabled in all VPCs' as title,
  aws_ec2_vpcs.account_id,
  aws_ec2_vpcs.arn,
  case when
      aws_ec2_flow_logs.resource_id is null
      then 'fail'
      else 'pass'
  end as status
from aws_ec2_vpcs
left join aws_ec2_flow_logs on
        aws_ec2_vpcs.vpc_id = aws_ec2_flow_logs.resource_id
{% endmacro %}

{% macro postgres__flow_logs_enabled_in_all_vpcs(framework, check_id) %}
select
  DISTINCT
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'VPC flow logging should be enabled in all VPCs' as title,
  aws_ec2_vpcs.account_id,
  aws_ec2_vpcs.arn,
  case when
      aws_ec2_flow_logs.resource_id is null
      then 'fail'
      else 'pass'
  end as status
from aws_ec2_vpcs
left join aws_ec2_flow_logs on
        aws_ec2_vpcs.vpc_id = aws_ec2_flow_logs.resource_id
{% endmacro %}

{% macro bigquery__flow_logs_enabled_in_all_vpcs(framework, check_id) %}
select
  DISTINCT
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'VPC flow logging should be enabled in all VPCs' as title,
  aws_ec2_vpcs.account_id,
  aws_ec2_vpcs.arn,
  case when
      aws_ec2_flow_logs.resource_id is null
      then 'fail'
      else 'pass'
  end as status
from {{ full_table_name("aws_ec2_vpcs") }}
left join {{ full_table_name("aws_ec2_flow_logs") }} on
        aws_ec2_vpcs.vpc_id = aws_ec2_flow_logs.resource_id
{% endmacro %}

{% macro athena__flow_logs_enabled_in_all_vpcs(framework, check_id) %}
SELECT
    DISTINCT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'VPC flow logging should be enabled in all VPCs' AS title,
    aws_ec2_vpcs.account_id,
    aws_ec2_vpcs.arn AS resource_id,
    CASE 
        WHEN aws_ec2_flow_logs.resource_id IS NULL THEN 'fail'
        ELSE 'pass'
    END AS status
FROM 
    aws_ec2_vpcs
LEFT JOIN 
    aws_ec2_flow_logs ON aws_ec2_vpcs.vpc_id = aws_ec2_flow_logs.resource_id
{% endmacro %}