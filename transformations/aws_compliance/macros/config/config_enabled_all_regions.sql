{% macro config_enabled_all_regions(framework, check_id) %}
  {{ return(adapter.dispatch('config_enabled_all_regions')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__config_enabled_all_regions(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'AWS Config should be enabled' as title,
    account_id,
    arn as resource_id,
    CASE 
        WHEN ((recording_group:IncludeGlobalResourceTypes::BOOLEAN != TRUE) OR (recording_group:AllSupported::BOOLEAN != TRUE) OR (status_recording != TRUE OR status_last_status != 'SUCCESS'))
    THEN 'fail'
    ELSE 'pass'
    END AS status
FROM
    aws_config_configuration_recorders
{% endmacro %}

{% macro postgres__config_enabled_all_regions(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'AWS Config should be enabled' as title,
    account_id,
    arn as resource_id,
    case when
      (recording_group->>'IncludeGlobalResourceTypes')::boolean IS NOT TRUE
      OR (recording_group->>'AllSupported')::boolean IS NOT TRUE
      OR status_recording IS NOT TRUE
      OR status_last_status IS DISTINCT FROM 'SUCCESS'
    then 'fail'
    else 'pass'
    end as status
FROM
    aws_config_configuration_recorders
{% endmacro %}
