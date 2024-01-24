{% macro autoscaling_launch_config_public_ip_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('autoscaling_launch_config_public_ip_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__autoscaling_launch_config_public_ip_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__autoscaling_launch_config_public_ip_disabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Amazon EC2 instances launched using Auto Scaling group launch configurations should not have Public IP addresses' AS "title",
  account_id,
  arn AS resource_id,
  case
  when associate_public_ip_address = true then 'fail'
    else 'pass'
  END
    AS status
FROM
  aws_autoscaling_launch_configurations
{% endmacro %}

{% macro snowflake__autoscaling_launch_config_public_ip_disabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Amazon EC2 instances launched using Auto Scaling group launch configurations should not have Public IP addresses' AS "title",
  account_id,
  arn AS resource_id,
  case
  when associate_public_ip_address = true then 'fail'
    else 'pass'
  END
    AS status
FROM
  aws_autoscaling_launch_configurations
{% endmacro %}

{% macro bigquery__autoscaling_launch_config_public_ip_disabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Amazon EC2 instances launched using Auto Scaling group launch configurations should not have Public IP addresses' AS title,
  account_id,
  arn AS resource_id,
  case
  when associate_public_ip_address = true then 'fail'
    else 'pass'
  END
    AS status
FROM
  {{ full_table_name("aws_autoscaling_launch_configurations") }}
{% endmacro %}