{% macro compute_guestconfiguration_windowsloganalyticsagentconnection_aine(framework, check_id) %}
WITH installed AS (
	SELECT
		DISTINCT _cq_id
    FROM azure_compute_virtual_machines, jsonb_array_elements(resources) AS res
	WHERE
		res->>'publisher' = 'Microsoft.EnterpriseCloud.Monitoring'
		AND res->>'type' IN ( 'MicrosoftMonitoringAgent', 'OmsAgentForLinux' )
		AND res->>'provisioningState' = 'Succeeded'
		AND res->'settings'->>'workspaceId' IS NOT NULL -- TODO check
)

SELECT
  azure_compute_virtual_machines.id AS resource_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Audit Windows machines on which the Log Analytics agent is not connected as expected',
  azure_compute_virtual_machines.subscription_id,
  case
    when azure_compute_virtual_machines.properties -> 'storageProfile' -> 'osDisk' ->> 'osType' = 'Windows'
      AND installed._cq_id IS NULL
    then 'fail'
    else 'pass'
  end
FROM
	azure_compute_virtual_machines
	LEFT JOIN installed ON azure_compute_virtual_machines._cq_id = installed._cq_id
{% endmacro %}