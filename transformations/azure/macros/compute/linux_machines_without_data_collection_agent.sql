{% macro compute_linux_machines_without_data_collection_agent(framework, check_id) %}
WITH secured_vms AS ( SELECT vm.id as compute_virtual_machine_id
                      FROM azure_compute_virtual_machines vm left join azure_compute_virtual_machine_extensions ex on vm._cq_id = ex._cq_parent_id
                     WHERE ex.properties ->> 'publisher' = 'DependencyAgentLinux'
                       AND ex.properties ->> 'type' = 'Microsoft.Azure.Monitoring.DependencyAgent'
                       AND ex.properties ->> 'provisioningState' = 'Succeeded')

SELECT
  vms.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  '[Preview]: Network traffic data collection agent should be installed on Linux virtual machines',
  vms.subscription_id,
  case
    when vms.properties -> 'storageProfile' -> 'osDisk' ->> 'osType' = 'Linux'
      and s.compute_virtual_machine_id IS NULL then 'fail' else 'pass'
  end
FROM azure_compute_virtual_machines vms
         LEFT JOIN secured_vms s ON vms.id = s.compute_virtual_machine_id
{% endmacro %}