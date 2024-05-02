{% macro autoscaling_launchconfig_requires_imdsv2(framework, check_id) %}
  {{ return(adapter.dispatch('autoscaling_launchconfig_requires_imdsv2')(framework, check_id)) }}
{% endmacro %}

{% macro default__autoscaling_launchconfig_requires_imdsv2(framework, check_id) %}{% endmacro %}

{% macro postgres__autoscaling_launchconfig_requires_imdsv2(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Auto Scaling group launch configurations should configure EC2 instances to require Instance Metadata Service Version 2' AS "title",
  account_id,
  arn AS resource_id,
  case
  when METADATA_OPTIONS ->> 'HttpTokens' = 'required' then 'pass'
    else 'fail'
  END
    AS status
FROM
  aws_autoscaling_launch_configurations
{% endmacro %}

{% macro snowflake__autoscaling_launchconfig_requires_imdsv2(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Auto Scaling group launch configurations should configure EC2 instances to require Instance Metadata Service Version 2' AS "title",
  account_id,
  arn AS resource_id,
  case
  when METADATA_OPTIONS:HttpTokens = 'required' then 'pass'
    else 'fail'
  END
    AS status
FROM
  aws_autoscaling_launch_configurations
{% endmacro %}

{% macro bigquery__autoscaling_launchconfig_requires_imdsv2(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Auto Scaling group launch configurations should configure EC2 instances to require Instance Metadata Service Version 2' AS title,
  account_id,
  arn AS resource_id,
  case
  when JSON_VALUE(METADATA_OPTIONS.HttpTokens) = 'required' then 'pass'
    else 'fail'
  END
    AS status
FROM
  {{ full_table_name("aws_autoscaling_launch_configurations") }}
{% endmacro %}

{% macro athena__autoscaling_launchconfig_requires_imdsv2(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Auto Scaling group launch configurations should configure EC2 instances to require Instance Metadata Service Version 2' AS "title",
  account_id,
  arn AS resource_id,
  case
  when json_extract_scalar(METADATA_OPTIONS, '$.HttpTokens') = 'required' then 'pass'
    else 'fail'
  END
    AS status
FROM
  aws_autoscaling_launch_configurations
{% endmacro %}