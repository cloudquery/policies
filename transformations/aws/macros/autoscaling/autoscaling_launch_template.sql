{% macro autoscaling_launch_template(framework, check_id) %}
  {{ return(adapter.dispatch('autoscaling_launch_template')(framework, check_id)) }}
{% endmacro %}

{% macro default__autoscaling_launch_template(framework, check_id) %}{% endmacro %}

{% macro postgres__autoscaling_launch_template(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Amazon EC2 Auto Scaling groups should use Amazon EC2 launch templates' AS "title",
  account_id,
  arn AS resource_id,
  case
  when (LAUNCH_TEMPLATE)::Text is null then 'fail'
    else 'pass'
  END
    AS status
FROM
  aws_autoscaling_groups
{% endmacro %}

{% macro snowflake__autoscaling_launch_template(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Amazon EC2 Auto Scaling groups should use Amazon EC2 launch templates' AS "title",
  account_id,
  arn AS resource_id,
  case
  when LAUNCH_TEMPLATE::String is null then 'fail'
    else 'pass'
  END
    AS status
FROM
  aws_autoscaling_groups
{% endmacro %}

{% macro bigquery__autoscaling_launch_template(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Amazon EC2 Auto Scaling groups should use Amazon EC2 launch templates' AS title,
  account_id,
  arn AS resource_id,
  case
  when CAST(JSON_VALUE(LAUNCH_TEMPLATE) AS STRING) is null then 'fail'
    else 'pass'
  END
    AS status
FROM
  {{ full_table_name("aws_autoscaling_groups") }}
{% endmacro %}