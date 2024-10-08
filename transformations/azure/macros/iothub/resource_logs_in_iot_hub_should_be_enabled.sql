{% macro iothub_resource_logs_in_iot_hub_should_be_enabled(framework, check_id) %}
WITH logging_enabled AS (
  SELECT DISTINCT h.cq_id
  FROM azure_iothub_hubs h
           LEFT JOIN azure_monitor_diagnostic_settings s ON h.id = s.resource_id
           LEFT JOIN azure_monitor_diagnostic_setting_logs l
                     ON s.cq_id = l.diagnostic_setting_cq_id
  WHERE l.enabled = TRUE
    AND l.category = 'AuditEvent'
    AND (s.properties -> 'storageAccountId' as storage_account_id IS NOT NULL OR s.properties ->> 'storageAccountId' as storage_account_id IS DISTINCT FROM '')
    AND retention_policy_enabled = TRUE
)

SELECT
  :'execution_time'
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  '',
  subscription_id,
  id,
  case
    when e.cq_id is null then 'fail' else 'pass'
  end
FROM azure_iothub_hubs h
         LEFT JOIN logging_enabled e ON h.cq_id = e.cq_id
{% endmacro %}