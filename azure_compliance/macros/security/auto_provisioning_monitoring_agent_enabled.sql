{% macro security_auto_provisioning_monitoring_agent_enabled(framework, check_id) %}

SELECT
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that "Automatic provisioning of monitoring agent" is set to "On" (Automated)' as title,
  subscription_id,
  id,
  case
    when properties->>'autoProvision' = 'On'
    then 'pass' else 'fail'
  end
FROM azure_security_auto_provisioning_settings asaps
WHERE "name" = 'default'{% endmacro %}