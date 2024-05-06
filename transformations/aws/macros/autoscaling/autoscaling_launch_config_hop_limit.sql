{% macro autoscaling_launch_config_hop_limit(framework, check_id) %}
  {{ return(adapter.dispatch('autoscaling_launch_config_hop_limit')(framework, check_id)) }}
{% endmacro %}

{% macro default__autoscaling_launch_config_hop_limit(framework, check_id) %}{% endmacro %}

{% macro postgres__autoscaling_launch_config_hop_limit(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Auto Scaling group launch configuration should not have a metadata response hop limit greater than 1' AS "title",
  account_id,
  arn AS resource_id,
  case
  when (METADATA_OPTIONS ->> 'HttpPutResponseHopLimit')::integer > 1 then 'fail'
    else 'pass'
  END
    AS status
FROM
  aws_autoscaling_launch_configurations
{% endmacro %}

{% macro snowflake__autoscaling_launch_config_hop_limit(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Auto Scaling group launch configuration should not have a metadata response hop limit greater than 1' AS "title",
  account_id,
  arn AS resource_id,
  case
  when METADATA_OPTIONS:HttpPutResponseHopLimit > 1 then 'fail'
    else 'pass'
  END
    AS status
FROM
  aws_autoscaling_launch_configurations
{% endmacro %}

{% macro bigquery__autoscaling_launch_config_hop_limit(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Auto Scaling group launch configuration should not have a metadata response hop limit greater than 1' AS title,
  account_id,
  arn AS resource_id,
  case
  when CAST(JSON_VALUE(METADATA_OPTIONS.HttpPutResponseHopLimit) AS INT64) > 1 then 'fail'
    else 'pass'
  END
    AS status
FROM
  {{ full_table_name("aws_autoscaling_launch_configurations") }}
{% endmacro %}

{% macro athena__autoscaling_launch_config_hop_limit(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Auto Scaling group launch configuration should not have a metadata response hop limit greater than 1' AS "title",
  account_id,
  arn AS resource_id,
  case
  when json_array_length(json_extract(METADATA_OPTIONS, '$.HttpPutResponseHopLimit')) > 1 then 'fail'
    else 'pass'
  END
    AS status
FROM
  aws_autoscaling_launch_configurations
{% endmacro %}