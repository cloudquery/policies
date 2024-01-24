{% macro autoscaling_multiple_az(framework, check_id) %}
  {{ return(adapter.dispatch('autoscaling_multiple_az')(framework, check_id)) }}
{% endmacro %}

{% macro default__autoscaling_multiple_az(framework, check_id) %}{% endmacro %}

{% macro postgres__autoscaling_multiple_az(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Amazon EC2 Auto Scaling group should cover multiple Availability Zones' AS "title",
  account_id,
  arn AS resource_id,
  case
  when array_length(availability_zones, 1) > 1 then 'pass'
  else 'fail'
  END
    AS status
FROM
  aws_autoscaling_groups
{% endmacro %}

{% macro snowflake__autoscaling_multiple_az(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Amazon EC2 Auto Scaling group should cover multiple Availability Zones' AS "title",
  account_id,
  arn AS resource_id,
  case
  when ARRAY_SIZE(availability_zones) > 1 then 'pass'
  else 'fail'
  END
    AS status
FROM
  aws_autoscaling_groups
{% endmacro %}

{% macro bigquery__autoscaling_multiple_az(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Amazon EC2 Auto Scaling group should cover multiple Availability Zones' AS title,
  account_id,
  arn AS resource_id,
  case
  when ARRAY_LENGTH(availability_zones) > 1 then 'pass'
  else 'fail'
  END
    AS status
FROM
  {{ full_table_name("aws_autoscaling_groups") }}
{% endmacro %}