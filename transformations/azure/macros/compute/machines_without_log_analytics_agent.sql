{% macro compute_machines_without_log_analytics_agent(framework, check_id) %}
WITH secured_vms AS (SELECT _cq_id
                     FROM azure_compute_virtual_machines, jsonb_array_elements(resources) AS res
                     WHERE res->>'type' IN ('MicrosoftMonitoringAgent', 'OmsAgentForLinux')
                       AND res->>'publisher' = 'Microsoft.EnterpriseCloud.Monitoring'
                       AND res->>'provisioningState' = 'Succeeded'
                       AND res->'settings'->>'workspaceId' IS NOT NULL) -- TODO check

SELECT
  vms.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Virtual machines should have the Log Analytics extension installed',
  vms.subscription_id,
  case
    when s._cq_id IS NULL then 'fail' else 'pass'
  end
FROM azure_compute_virtual_machines vms
         LEFT JOIN secured_vms s ON vms._cq_id = s._cq_id
{% endmacro %}